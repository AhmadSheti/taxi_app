import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../blocked_drivers/view/blocked_drivers_screen.dart';
import '../../notifications/view/notifications_screen.dart';
import '../../info/view/info_screens.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController()..fetchProfile(),
      builder: (c) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: c.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _header(c),
                      const SizedBox(height: 16),
                      _stats(c),
                      const SizedBox(height: 20),
                      _menu(
                        icon: Icons.block,
                        title: 'السائقون المحظورون',
                        onTap: () => Get.to(() => const BlockedDriversScreen()),
                      ),
                    
                      _menu(
                        icon: Icons.help_outline,
                        title: 'المساعدة والدعم',
                        onTap: () => Get.to(() => const HelpSupportScreen()),
                      ),
                      _menu(
                        icon: Icons.privacy_tip_outlined,
                        title: 'سياسة الخصوصية',
                        onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                      ),
                      _menu(
                        icon: Icons.description_outlined,
                        title: 'الشروط والأحكام',
                        onTap: () => Get.to(() => const TermsScreen()),
                      ),
                      _menu(
                        icon: Icons.info_outline,
                        title: 'عن التطبيق',
                        onTap: () => Get.to(() => const AboutScreen()),
                      ),
                      const SizedBox(height: 12),
                      _menu(
                        icon: Icons.logout,
                        title: 'تسجيل الخروج',
                        color: AppColors.danger,
                        onTap: c.confirmLogout,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _header(ProfileController c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.primaryTeal, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.secondaryAmber,
            child: Text(
              c.name.isNotEmpty ? c.name.substring(0, 1) : '؟',
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name.isEmpty ? 'مستخدم مشوار' : c.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(c.phone,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats(ProfileController c) {
    Widget item(String value, String label) => Expanded(
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal)),
              const SizedBox(height: 4),
              Text(label, style: AppStyles.bodyRegular),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: AppColors.cardWhite, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          item('${c.totalRides}', 'إجمالي الرحلات'),
          Container(width: 1, height: 40, color: Colors.black12),
          item('${c.completedRides}', 'مكتملة'),
        ],
      ),
    );
  }

  Widget _menu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.textMain,
  }) {
    return Card(
      color: AppColors.cardWhite,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
