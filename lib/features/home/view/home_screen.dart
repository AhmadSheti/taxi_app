import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../destination/view/destination_screen.dart';
// تأكد من تغيير المسار لتضمين ملف الثوابت الخاص بك
// import 'package:mishwar/theme/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // إجبار الواجهة على التوجه من اليمين إلى اليسار (RTL) كما هو محدد في دليل التصميم
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // 1. خلفية الخريطة (محاكاة الخريطة بوضع صورة أو لون هادئ)
            Positioned.fill(
              child: Container(
                color: const Color(
                  0xFFE4EEF1,
                ), // لون الخلفية الهادئة المذكور في الدليل
                child: Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 120,
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            // 2. شريط الترحيب العلوي والسائقين المتاحين
            Positioned(
              top: 50.0,
              left: 20.0,
              right: 20.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ترحيب مخصص بالمستخدم (نبرة صوت ودودة)
                  Text(
                    'صباح الخير، أحمد',
                    style: AppStyles.headingBold.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),

                  // شارة السائقين المتاحين قرب المستخدم
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '٢٧ سائقًا متاحًا قربك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. البطاقة السفلية العائمة لحجز رحلة جديدة
            Positioned(
              bottom: 24.0,
              left: 20.0,
              right: 20.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textMain.withOpacity(0.08),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان البطاقة
                    const Text(
                      'حجز رحلة جديدة',
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // حقل إدخال الوجهة (محاكاة زر تفاعلي)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  DestinationScreen(),
                          ),
                        );
                        // هنا يتم الانتقال لشاشة طلب رحلة واختيار الوجهة مستقبلاً
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFE6E6EE,
                            ), // لون الفواصل والإطارات من الدليل
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: AppColors.primaryTeal,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'إلى أين تريد الذهاب؟',
                              style: AppStyles.bodyRegular.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
