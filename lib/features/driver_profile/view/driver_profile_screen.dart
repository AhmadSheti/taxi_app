import 'package:flutter/material.dart';
import '../../car_details/view/car_details_screen.dart';
import '../../company_commission/view/company_commission_screen.dart';
import '../../personal_info/view/personal_info_placeholder.dart';
import '../../help/view/help_placeholder.dart';
import '../../notifications/view/notifications_screen.dart';
import '../../blocked_users/view/blocked_users_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  final Color tealColor = const Color(0xFF00B4A0);
  final Color darkBlue = const Color(0xFF0D3E46);
  final Color bgLight = const Color(0xFFF7F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'الملف الشخصي',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CarDetailsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'فادي خوري',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'كابتن منذ ٢٠٢٣',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: const [
                                        Text(
                                          '٤.٩',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFFFFB822),
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: const Color(0xFFF39C12),
                                child: const Text(
                                  'ف',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: tealColor,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ],
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
                      _buildStatCard('كابتن ذهبي', 'مستوى'),
                      _buildStatCard('٢٨,٤٠٠', 'جم'),
                      _buildStatCard('١,٢٤٠', 'رحلة'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuCard(
                    title: 'ملفي',
                    subtitle: 'المعلومات الشخصية',
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalInfoPlaceholder(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'سيارتي',
                    subtitle: 'هيونداي إلنترا',
                    icon: Icons.directions_car_filled_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'المحفظة والعمولة',
                    subtitle: 'مستحق',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyCommissionScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'الزبائن المحظورون',
                    subtitle: '',
                    icon: Icons.block,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BlockedUsersScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'الإشعارات',
                    subtitle: '',
                    icon: Icons.notifications_none_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ), // إذا كان لديكِ كلاس للإشعارات
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'المساعدة والدعم',
                    subtitle: '',
                    icon: Icons.help_outline_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpPlaceholder(),
                        ), // استبدلي باسم كلاس صفحة المساعدة
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'مشوار - سائق . إصدار ٢.١',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: darkBlue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
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
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.grey,
          size: 14,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Spacer(),
            ],
            Text(
              title,
              style: TextStyle(
                color: darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: darkBlue, size: 20),
        ),
      ),
    );
  }
}
