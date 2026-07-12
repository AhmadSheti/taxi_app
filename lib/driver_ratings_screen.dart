import 'package:flutter/material.dart';
import 'driver_profile_screen.dart';

class DriverRatingsScreen extends StatelessWidget {
  const DriverRatingsScreen({super.key});

  // الألوان المعتمدة بتطبيق مشوار
  final Color tealColor = const Color(0xFF00B4A0);
  final Color darkBlue = const Color(0xFF0D3E46);
  final Color bgLight = const Color(0xFFF7F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: darkBlue, size: 18),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DriverProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. كرت إجمالي التقييمات والنجوم والنسب المئوية
            _buildSummaryCard(),

            const SizedBox(height: 20),

            // 2. كرت اتجاه التقييم عبر الأشهر (الرسم البياني المبسط)
            _buildTrendCard(),

            const SizedBox(height: 25),

            // 3. قسم أحدث التعليقات
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

            _buildCommentCard(
              name: 'أحمد العلي',
              initials: 'أ',
              avatarColor: const Color(0xFF1F5E6B),
              time: 'منذ ١٤ د',
              rating: 5,
              comment: 'سائق محترم جداً وقيادة آمنة، أنصح به بشدة!',
            ),
            _buildCommentCard(
              name: 'ليلى مرعي',
              initials: 'ل',
              avatarColor: const Color(0xFF9B6BFF),
              time: '٩:١٢ ص',
              rating: 4,
              comment: 'لطيف ودقيق في الموعد، السيارة نظيفة.',
            ),
            _buildCommentCard(
              name: 'خليل العطار',
              initials: 'خ',
              avatarColor: const Color(0xFFF39C12),
              time: 'أمس',
              rating: 5,
              comment: 'خدمة ممتازة وسريع بالوصول.',
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت بناء كرت إجمالي التقييمات (القسم العلوي)
  Widget _buildSummaryCard() {
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
                _buildRatingBar(5, 0.8, '٨٠%'),
                _buildRatingBar(4, 0.15, '١٥%'),
                _buildRatingBar(3, 0.03, '٣%'),
                _buildRatingBar(2, 0.01, '١%'),
                _buildRatingBar(1, 0.01, '١%'),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // الرقم الكبير والنجوم على اليمين
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '٤.٩',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFFFB822),
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'من ١٨٢ تقييم',
                style: TextStyle(color: Colors.grey, fontSize: 11),
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
                value: progress,
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
          const Icon(Icons.star, color: Color(0xFFFFB822), size: 11),
        ],
      ),
    );
  }

  // كرت اتجاه التقييم (الرسم البياني عبر الأشهر)
  Widget _buildTrendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ثابت +',
                  style: TextStyle(
                    color: tealColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'اتجاه التقييم',
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // شكل منحنى بياني محاكي للتصميم الأصلي باستخدام CustomPaint ليعطي جمالية ومظهر حقيقي
          SizedBox(
            height: 60,
            child: CustomPaint(painter: _TrendLinePainter(tealColor)),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('مايو', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('أبريل', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('مارس', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text(
                'فبراير',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Text('يناير', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  // كرت التعليق الفردي للمستخدمين
  Widget _buildCommentCard({
    required String name,
    required String initials,
    required Color avatarColor,
    required String time,
    required int rating,
    required String comment,
  }) {
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
                time,
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
                        color: index < rating
                            ? const Color(0xFFFFB822)
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
                backgroundColor: avatarColor,
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
      ),
    );
  }
}

// كلاس لرسم خط المنحنى
class _TrendLinePainter extends CustomPainter {
  final Color lineColor;
  _TrendLinePainter(this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // إحداثيات لرسم خط متعرج صاعد
    path.moveTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 0.75, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height * 0.55);
    path.lineTo(size.width * 0.25, size.height * 0.3);
    path.lineTo(0, size.height * 0.35);

    //رسم الظل الفاتح
    final fillPath = Path.from(path)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = lineColor.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
