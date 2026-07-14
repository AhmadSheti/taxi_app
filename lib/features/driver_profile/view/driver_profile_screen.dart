import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/driver_profile_controller.dart';
import '../../car_details/view/car_details_screen.dart';
import '../../personal_info/view/personal_info_screen.dart';
import '../../info/view/info_screens.dart';
import '../../notifications/view/notifications_screen.dart';
import '../../blocked_users/view/blocked_users_screen.dart';
import '../../driver_ratings/view/driver_ratings_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<DriverProfileController>(
        initState: (_) => Get.find<DriverProfileController>().load(),
        builder: (c) => Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            onRefresh: c.load,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _header(c),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _menuCard(
                          title: 'المعلومات الشخصية',
                          subtitle: c.data?['phone']?.toString() ?? '',
                          icon: Icons.person_outline,
                          onTap: () => Get.to(() => const PersonalInfoScreen()),
                        ),
                        _menuCard(
                          title: 'سيارتي',
                          subtitle: c.carLabel,
                          icon: Icons.directions_car_filled_outlined,
                          onTap: () => Get.to(() => const CarDetailsScreen()),
                        ),
                        _menuCard(
                          title: 'تقييماتي',
                          subtitle: '${c.ratingAverage} ★',
                          icon: Icons.star_border,
                          onTap: () => Get.to(() => const DriverRatingsScreen()),
                        ),
                        _menuCard(
                          title: 'الزبائن المحظورون',
                          subtitle: '',
                          icon: Icons.block,
                          onTap: () => Get.to(() => const BlockedUsersScreen()),
                        ),
                        _menuCard(
                          title: 'الإشعارات',
                          subtitle: '',
                          icon: Icons.notifications_none_outlined,
                          onTap: () => Get.to(() => const NotificationsScreen()),
                        ),
                        _menuCard(
                          title: 'المساعدة والدعم',
                          subtitle: '',
                          icon: Icons.help_outline_outlined,
                          onTap: () => Get.to(() => const HelpSupportScreen()),
                        ),
                        _menuCard(
                          title: 'سياسة الخصوصية',
                          subtitle: '',
                          icon: Icons.privacy_tip_outlined,
                          onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                        ),
                        _menuCard(
                          title: 'الشروط والأحكام',
                          subtitle: '',
                          icon: Icons.description_outlined,
                          onTap: () => Get.to(() => const TermsScreen()),
                        ),
                        _menuCard(
                          title: 'عن التطبيق',
                          subtitle: '',
                          icon: Icons.info_outline,
                          onTap: () => Get.to(() => const AboutScreen()),
                        ),
                        const SizedBox(height: 8),
                        _logoutCard(context, c),
                        const SizedBox(height: 16),
                        const Text('مشوار - سائق · إصدار ٢.١',
                            style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(DriverProfileController c) {
    final initial = c.name.isNotEmpty ? c.name.characters.first : 'س';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
              const Text('الملف الشخصي',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(c.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text('${c.ratingAverage}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 3),
                            const Icon(Icons.star,
                                color: AppColors.accent, size: 13),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.accent,
                    child: Text(initial,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -40,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statCard('${c.totalRides}', 'رحلة'),
              _statCard('${c.ratingAverage}', 'تقييم'),
              _statCard(
                  (c.data?['availability'] == 'online') ? 'متصل' : 'غير متصل',
                  'الحالة'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      // نبني الصفّ يدوياً بدل ListTile: في وضع RTL يُرتَّب الأبناء من اليمين
      // لليسار، فتظهر الأيقونة الملوّنة يميناً، النص محاذى لليمين، والسهم يساراً.
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // 1) الأيقونة الملوّنة (تظهر يميناً في RTL)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                // 2) العنوان + الوصف (يملأ المساحة، محاذى لليمين تلقائياً في RTL)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      if (subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(subtitle,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // 3) سهم الانتقال (يظهر يساراً في RTL)
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutCard(BuildContext context, DriverProfileController c) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _confirmLogout(context, c),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // الأيقونة يميناً في RTL
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout, color: AppColors.danger, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('تسجيل الخروج',
                      style: TextStyle(
                          color: AppColors.danger, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, DriverProfileController c) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                c.logout();
              },
              child: const Text('خروج',
                  style: TextStyle(color: AppColors.danger)),
            ),
          ],
        ),
      ),
    );
  }
}
