import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/driver_ratings_controller.dart';
import '../model/rating_model.dart';

class DriverRatingsScreen extends StatelessWidget {
  const DriverRatingsScreen({super.key});

  // الألوان المعتمدة بتطبيق مشوار
  final Color tealColor = const Color(0xFF00B4A0);
  final Color darkBlue = const Color(0xFF0D3E46);
  final Color bgLight = const Color(0xFFF7F9FA);
  final Color starColor = const Color(0xFFFFB822);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<DriverRatingsController>(
        initState: (_) => Get.find<DriverRatingsController>().load(),
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black), // السهم
              onPressed: () {
                Navigator.pop(
                  context,
                ); // هذا الأمر يقوم بإغلاق الصفحة الحالية والعودة للخلف
              },
            ),
            title: Text(
              'تقييماتي',
              style: TextStyle(
                color: darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. كرت إجمالي التقييمات والنجوم والنسب المئوية
                      _buildSummaryCard(controller),

                      const SizedBox(height: 25),

                      // 2. قسم أحدث التعليقات
                      Text(
                        'أحدث التعليقات',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (controller.ratings.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'لا توجد تقييمات بعد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        ...controller.ratings
                            .map((rating) => _buildCommentCard(rating)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ويدجت بناء كرت إجمالي التقييمات (القسم العلوي)
  Widget _buildSummaryCard(DriverRatingsController controller) {
    final summary = controller.summary;
    final double average = summary?.average ?? 0;
    final int totalCount = summary?.totalCount ?? 0;
    final Map<int, int> distribution = summary?.distribution ?? const {};

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // تفاصيل الـ Progress Bars على اليسار
          Expanded(
            child: Column(
              children: [
                for (int star = 5; star >= 1; star--)
                  _buildRatingBar(
                    star,
                    totalCount == 0
                        ? 0
                        : (distribution[star] ?? 0) / totalCount,
                    totalCount == 0
                        ? '٠%'
                        : _toArabicPercent(
                            ((distribution[star] ?? 0) / totalCount) * 100,
                          ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // الرقم الكبير والنجوم على اليمين
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _toArabicNumber(average.toStringAsFixed(1)),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < average.round() ? Icons.star : Icons.star_border,
                    color: starColor,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'من ${_toArabicNumber(totalCount.toString())} تقييم',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // سطر شريط التقييم لكل نجمة
  Widget _buildRatingBar(int starNum, double progress, String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            percent,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.left,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  starNum >= 4
                      ? tealColor
                      : (starNum == 3
                            ? Colors.red.shade400
                            : Colors.grey.shade400),
                ),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$starNum',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, color: starColor, size: 11),
        ],
      ),
    );
  }

  // كرت التعليق الفردي للمستخدمين
  Widget _buildCommentCard(RatingModel rating) {
    final String name =
        rating.customerName.isEmpty ? 'عميل' : rating.customerName;
    final String initials = name.trim().isEmpty ? '؟' : name.trim()[0];
    final String comment = (rating.comment ?? '').trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                _formatDate(rating.createdAt),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < rating.score
                            ? starColor
                            : Colors.grey.shade300,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 16,
                backgroundColor: _avatarColor(name),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, color: Color(0xFFF1F1F1)),
            ),
            Text(
              comment,
              textAlign: TextAlign.right,
              style: TextStyle(color: darkBlue, fontSize: 12, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  // لون ثابت للأفاتار مشتق من الاسم للحفاظ على مظهر متنوع كالتصميم الأصلي
  Color _avatarColor(String name) {
    const colors = [
      Color(0xFF1F5E6B),
      Color(0xFF9B6BFF),
      Color(0xFFF39C12),
      Color(0xFF00B4A0),
      Color(0xFFE67E22),
    ];
    if (name.isEmpty) return colors.first;
    return colors[name.codeUnitAt(0) % colors.length];
  }

  // تحويل تاريخ ISO إلى صيغة مختصرة (يوم/شهر) أو إرجاعه كما هو عند الفشل
  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return _toArabicNumber('$d/$m');
  }

  String _toArabicPercent(double value) {
    return '${_toArabicNumber(value.round().toString())}%';
  }

  // تحويل الأرقام اللاتينية إلى أرقام عربية للتناسق مع باقي التصميم
  String _toArabicNumber(String input) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = input;
    for (var i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], arabic[i]);
    }
    return result;
  }
}
