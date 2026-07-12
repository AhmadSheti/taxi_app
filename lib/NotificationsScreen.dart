import 'package:flutter/material.dart';

// ملاحظة: استبدل هذه الألوان بالثوابت الموجودة في ملف الثوابت الخاص بك
class AppColors {
  static const Color background = Color(0xFFF7F9FA);  // لون خلفية الصفحة
  static const Color cardBackground = Colors.white;   // لون خلفية البطاقات البيضاء
  static const Color unreadBackground = Color(0xFFFFFDF6); // لون خلفية الإشعار غير المقروء (مائل للاصفرار)
  static const Color textDark = Color(0xFF1A1A1A);       // لون النصوص الداكنة والعناوين
  static const Color textGrey = Color(0xFF757575);       // لون النصوص الرمادية والوصف
  static const Color primaryBlue = Color(0xFF0A4D5C);    // لون النصوص الرئيسية أو أزرار التحكم
  static const Color accentYellow = Color(0xFFFFB300);   // لون نقطة الإشعار غير المقروء وأيقونة التقييم
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضمان اتجاه الواجهة من اليمين لليسار
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _buildSectionHeader('اليوم'),
            _buildNotificationCard(
              title: 'كود خصم جديد!',
              body: 'استخدم كود MISHWAR10 للحصول على ١٠٪ خصم على رحلتك القادمة، ساري حتى نهاية الشهر.',
              time: 'منذ ٢ ساعة',
              icon: Icons.local_offer_outlined,
              iconBgColor: const Color(0xFF26C6DA), // لون مائل للفيروزي
              isUnread: true,
            ),
            _buildNotificationCard(
              title: 'انتهت رحلتك بنجاح',
              body: 'رحلتك مع سامر الحمصي إلى المالكي اكتملت، لا تنسى تقييم الرحلة.',
              time: '٩:٥٤ ص',
              icon: Icons.check_circle_outline,
              iconBgColor: const Color(0xFF006064), // لون زيتي داكن
              isUnread: true,
            ),
            _buildNotificationCard(
              title: 'سامر ردّ على تقييمك',
              body: 'شكراً جزيلاً على رحلتك الممتعة! نتطلع لخدمتك مجدداً.',
              time: '٨:٢١ ص',
              icon: Icons.star_border,
              iconBgColor: AppColors.accentYellow,
              isUnread: false,
            ),
            
            _buildSectionHeader('أمس'),
            _buildNotificationCard(
              title: 'ميزة جديدة: المفضلون',
              body: 'يمكنك الآن إضافة سائقيك المفضلين للحصول على رحلات أسرع.',
              time: 'أمس',
              icon: Icons.bolt,
              iconBgColor: const Color(0xFFAB47BC), // لون بنفسجي
              isUnread: false,
            ),
            _buildNotificationCard(
              title: 'تحديث سياسة الخصوصية',
              body: 'لقد قمنا بتحديث سياسة الخصوصية، اطلع على التغييرات.',
              time: 'أمس',
              icon: Icons.shield_outlined,
              iconBgColor: const Color(0xFF103038), // لون كحلي داكن
              isUnread: false,
            ),
            
            _buildSectionHeader('الأسبوع الماضي'),
            _buildNotificationCard(
              title: 'تم إلغاء الرحلة',
              body: 'ألغى السائق محمد العبد رحلتك، تم استرداد المبلغ بالكامل.',
              time: 'الأحد',
              icon: Icons.close,
              iconBgColor: const Color(0xFFEF5350), // لون أحمر
              isUnread: false,
            ),
            _buildNotificationCard(
              title: 'إيصال رحلتك جاهز',
              body: 'تم إصدار إيصال الدفع لرحلتك الأخيرة، يمكنك استعراضه الآن.',
              time: 'الجمعة',
              icon: Icons.receipt_long_outlined,
              iconBgColor: const Color(0xFF455A64), // لون رمادي داكن
              isUnread: false,
            ),
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
          TextButton(
            onPressed: () {},
            child: const Text(
              'تحديد الكل كمقروء',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'الإشعارات',
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
              icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textDark, size: 16),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت عنوان القسم الزمني (اليوم، أمس، إلخ)
Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10, right: 4),
    child: Text(
      title,
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}


  // بطاقة الإشعار المخصصة القابلة لإعادة الاستخدام
  Widget _buildNotificationCard({
    required String title,
    required String body,
    required String time,
    required IconData icon,
    required Color iconBgColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.unreadBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أيقونة نوع الإشعار الخلفية الملونة
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            
            // تفاصيل نص الإشعار
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                      height: 1.4, // لزيادة تباعد الأسطر لراحة القراءة
                    ),
                  ),
                ],
              ),
            ),
            
            // نقطة الإشعار غير المقروء (تظهر فقط إذا كان isUnread صحيحاً)
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accentYellow,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
