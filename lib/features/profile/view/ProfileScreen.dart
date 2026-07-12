import 'package:flutter/material.dart';
import '../../../constants.dart';
// ملاحظة: استبدل هذه الألوان بالثوابت الموجودة في ملف الثوابت الخاص بك
class AppColors {
  static const Color primaryDark = Color(0xFF0A4D5C); // اللون الزيتي/الأزرق الداكن العلوي
  static const Color background = Color(0xFFF7F9FA);  // لون خلفية الصفحة
  static const Color cardBackground = Colors.white;   // لون خلفية البطاقات
  static const Color textDark = Color(0xFF1A1A1A);       // لون النصوص الداكنة
  static const Color textGrey = Color(0xFF757575);       // لون النصوص الرمادية
  static const Color accentYellow = Color(0xFFFFB300);   // لون دائرة الحرف والتقييم
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضمان اتجاه الواجهة من اليمين لليسار
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false, // ليمتد اللون الداكن إلى أعلى الشاشة (Status Bar)
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildProfileMenu(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // القسم العلوي الداكن (الهيدر)
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), // يمكنك تعديلها لو رغبت بانحناء سفلي
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          // شريط العنوان العلوي (أزرار التحكم والعنوان)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () {},
              ),
              const Text(
                'الملف الشخصي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // تفاصيل المستخدم (الصورة والاسم)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'أحمد العلي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عضو منذ ٢٠٢٤',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.accentYellow,
                    child: const Text(
                      'أ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: const Icon(Icons.camera_alt_outlined, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // إحصائيات المستخدم الرقمية (الإصدار، التقييم، المفضلون)
          Row(
            children: [
              Expanded(child: _buildStatCard('٣', 'مفضلون')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('٤.٩ ★', 'تقييم')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('٢٤', 'رحلة')),
            ],
          ),
        ],
      ),
    );
  }

  // ويدجت مخصصة لبناء كروت الإحصائيات الصغيرة
  Widget _buildStatCard(String value, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // قائمة الخيارات السفلية
  Widget _buildProfileMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // قائمة حسابي المنسدلة
          _buildMenuContainer([
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'حسابي',
              trailing: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildMenuItem(
              icon: Icons.badge_outlined,
              title: 'بيانات شخصية',
              showArrow: true,
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),

          // قائمة الأماكن والمستندات
          _buildMenuContainer([
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'الأماكن المفضلة',
              trailing: const Text('٣', style: TextStyle(color: AppColors.textGrey)),
              showArrow: true,
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),

          // الإعدادات واللغة
          _buildMenuContainer([
            _buildMenuItem(
              icon: Icons.notifications_none,
              title: 'الإشعارات',
              showArrow: true,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildMenuItem(
              icon: Icons.language,
              title: 'اللغة',
              trailing: const Text('العربية', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
              showArrow: true,
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),

          // الدعم وتسجيل الخروج
          _buildMenuContainer([
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'المساعدة والدعم',
              showArrow: true,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              titleColor: Colors.red,
              iconColor: Colors.red,
              showArrow: true,
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 24),

          // رقم الإصدار في الأسفل
          const Text(
            'إصدار ١.٤.٢ مشوار',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // حاوية موحدة لإعطاء تأثير المجموعات (Grouped Sections) كالحواف الدائرية والظل
  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // عنصر القائمة الفردي المخصص لتسهيل إعادة الاستخدام والتعديل
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color titleColor = AppColors.textDark,
    Color iconColor = AppColors.primaryDark,
    Widget? trailing,
    bool showArrow = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          if (trailing != null && showArrow) const SizedBox(width: 8),
          if (showArrow) const Icon(Icons.arrow_forward_ios, color: AppColors.textGrey, size: 14),
        ],
      ),
    );
  }
}
