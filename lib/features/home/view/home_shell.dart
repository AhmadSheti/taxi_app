import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../history/view/history_screen.dart';
import '../../notifications/view/notifications_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../controller/home_controller.dart';
import 'home_screen.dart';

/// الحاوية الرئيسية بعد الدخول: شريط تنقّل سفلي بأربعة تبويبات.
/// التبويب الحالي محفوظ في [HomeController] كي تتمكّن الشاشات من التنقّل بينها.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const _pages = [
    HomeScreen(),
    HistoryScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<HomeController>(
        builder: (c) => Scaffold(
          body: IndexedStack(index: c.tab, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: c.tab,
            onTap: c.changeTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.cardWhite,
            selectedItemColor: AppColors.primaryTeal,
            unselectedItemColor: AppColors.textSecondary,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'الرئيسية'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long),
                  label: 'رحلاتي'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined),
                  activeIcon: Icon(Icons.notifications),
                  label: 'الإشعارات'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'حسابي'),
            ],
          ),
        ),
      ),
    );
  }
}
