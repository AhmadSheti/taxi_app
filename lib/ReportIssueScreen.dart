import 'package:flutter/material.dart';

// ملاحظة: استبدل هذه الألوان بالثوابت الموجودة في ملف الثوابت الخاص بك
class AppColors {
  static const Color background = Color(0xFFF7F9FA); // لون خلفية الصفحة
  static const Color cardBackground =
      Colors.white; // لون خلفية البطاقات البيضاء
  static const Color textDark = Color(
    0xFF1A1A1A,
  ); // لون النصوص الداكنة والعناوين
  static const Color textGrey = Color(0xFF757575); // لون النصوص الرمادية والوصف
  static const Color primaryBlue = Color(
    0xFF0A4D5C,
  ); // لون النصوص الفرعية والأيقونات الدائرية
  static const Color accentYellow = Color(
    0xFFFFB300,
  ); // لون تحديد السبب المختار
  static const Color accentYellowBg = Color(
    0xFFFFFDF2,
  ); // لون خلفية السبب المختار
  static const Color infoGreenBg = Color(
    0xFFE0F2F1,
  ); // لون خلفية التنبيه الأخضر الخفيف
  static const Color infoGreenText = Color(0xFF00796B); // لون نص التنبيه الأخضر
  static const Color buttonRed = Color(
    0xFFEF5350,
  ); // لون زر إرسال البلاغ السفلي
}

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({Key? key}) : super(key: key);

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  // متغير لحفظ السبب المختار (محاكاة للتصميم حيث "قيادة غير آمنة" مختار)
  String selectedReason = 'قيادة غير آمنة';

  // وحدة التحكم بنص الوصف
  final TextEditingController _descriptionController = TextEditingController(
    text:
        'كان السائق يقود بسرعة عالية على الطريق السريع وتجاوز السيارات بشكل غير آمن...',
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضمان اتجاه الواجهة من اليمين لليسار
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('الرحلة المعنيّة'),
                    const SizedBox(height: 8),
                    _buildTripCard(),
                    const SizedBox(height: 20),

                    _buildSectionTitle('سبب البلاغ'),
                    const SizedBox(height: 12),
                    _buildReasonsGrid(),
                    const SizedBox(height: 20),

                    _buildSectionTitle('الوصف'),
                    const SizedBox(height: 8),
                    _buildDescriptionField(),
                    const SizedBox(height: 16),

                    _buildPrivacyInfoCard(),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // شريط العنوان العلوي (AppBar)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 40,
          ), // موازن لمكان زر العودة ليبقى العنوان بالمنتصف
          const Text(
            'الإبلاغ عن مشكلة',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textDark,
                size: 16,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت عناوين الأقسام الرئيسية
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textDark,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // كرت تفاصيل الرحلة المعنية
  Widget _buildTripCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios, color: AppColors.textGrey, size: 14),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'سامر الحمصي • المالكي',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'اليوم ٩:٤٢ ص • ٣٧٨٠ ل.س',
                style: TextStyle(color: AppColors.textGrey, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryBlue,
            child: Text(
              'س',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // شبكة أزرار أسباب البلاغ (Wrap لضمان التفاف العناصر حسب الحجم)
  Widget _buildReasonsGrid() {
    final reasons = [
      'قيادة غير آمنة',
      'أجرة غير صحيحة',
      'سلوك غير لائق',
      'نظافة السيارة',
      'أخرى',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: reasons.map((reason) {
        final isSelected = reason == selectedReason;
        return InkWell(
          onTap: () {
            setState(() {
              selectedReason = reason;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accentYellowBg
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.accentYellow
                    : Colors.grey.withOpacity(0.2),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              reason,
              style: TextStyle(
                color: isSelected ? AppColors.accentYellow : AppColors.textGrey,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // حقل إدخال النص الخاص بالوصف
  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 5,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'اكتب تفاصيل المشكلة هنا...',
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primaryBlue),
          ),
        ),
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }

  // كرت تنبيه الخصوصية الأخضر السفلي
  Widget _buildPrivacyInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.infoGreenBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(
            child: Text(
              'بلاغك سرّي تماماً. سيراجعه فريقنا خلال ٢٤ ساعة.',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.infoGreenText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.shield_outlined,
            color: AppColors.infoGreenText.withOpacity(0.8),
            size: 18,
          ),
        ],
      ),
    );
  }

  // زر إرسال البلاغ الثابت في الأسفل
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // هنا يمكنك إضافة منطق إرسال البلاغ
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال البلاغ بنجاح!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'إرسال البلاغ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
