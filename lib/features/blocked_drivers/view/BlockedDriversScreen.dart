import 'package:flutter/material.dart';

// ملاحظة: استبدل هذه الألوان بالثوابت الموجودة في ملف الثوابت الخاص بك
class AppColors {
  static const Color background = Color(0xFFF7F9FA);  // لون خلفية الصفحة
  static const Color cardBackground = Colors.white;   // لون خلفية البطاقات البيضاء
  static const Color textDark = Color(0xFF1A1A1A);       // لون النصوص الداكنة والعناوين
  static const Color textGrey = Color(0xFF757575);       // لون النصوص الرمادية والوصف
  static const Color primaryBlue = Color(0xFF0A4D5C);    // لون إطار زر إلغاء الحظر والنصوص الرئيسية
  static const Color textRed = Color(0xFFEF5350);        // لون الدائرة الحمراء (يوسف)
  static const Color textPurple = Color(0xFFAB47BC);     // لون الدائرة البنفسجية (خالد)
}

class BlockedDriversScreen extends StatelessWidget {
  const BlockedDriversScreen({Key? key}) : super(key: key);

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
            // بطاقة السائق الأول
            _buildDriverCard(
              name: 'يوسف الكردي',
              reason: 'سبب الحظر: تأخره في الوصول',
              date: 'تم الحظر في ١٢ مايو',
              avatarLetter: 'ي',
              avatarBgColor: AppColors.textRed,
              onUnblockPressed: () {},
            ),
            
            // بطاقة السائق الثاني
            _buildDriverCard(
              name: 'خالد المنير',
              reason: 'سبب الحظر: سلوك غير لائق',
              date: 'تم الحظر في ٥ مايو',
              avatarLetter: 'خ',
              avatarBgColor: AppColors.textPurple,
              onUnblockPressed: () {},
            ),
            const SizedBox(height: 16),
            
            // التلميح السفلي للحماية والإرشاد
            _buildInfoTipCard(),
          ],
        ),
      ),
    );
  }

  // شريط العنوان العلوي (AppBar) مع الوصف السفلي له
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 90, // زيادة الارتفاع ليتسع للعنوان والوصف الفرعي
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40), // موازن لمكان زر العودة ليبقى العنوان بالمنتصف
              const Text(
                'السائقون المحظورون',
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
          const SizedBox(height: 8),
          const Text(
            'لن تتمكن من طلب رحلة مع هؤلاء السائقين',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة السائق المحظور المخصصة والقابلة لإعادة الاستخدام
  Widget _buildDriverCard({
    required String name,
    required String reason,
    required String date,
    required String avatarLetter,
    required Color avatarBgColor,
    required VoidCallback onUnblockPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
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
          children: [
            // زر إلغاء الحظر (على الطرف الأيمن بالاتجاه العربي)
            OutlinedButton(
              onPressed: onUnblockPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryBlue, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: const Text(
                'إلغاء الحظر',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            
            // معلومات السائق النصية
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            
            // الصورة الرمزية الدائرية (الحرف الأول من الاسم)
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarBgColor,
              child: Text(
                avatarLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بطاقة الإرشاد والتلميح السفلي المحاطة بحدود خفيفة
  Widget _buildInfoTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Text(
              'تستطيع حظر السائق من شاشة الرحلة أو من تفاصيل الرحلة في «رحلاتي».',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.shield_outlined,
            color: Colors.grey.withOpacity(0.6),
            size: 20,
          ),
        ],
      ),
    );
  }
}
