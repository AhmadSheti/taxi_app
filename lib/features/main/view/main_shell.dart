import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../dashboard/view/dashbord_screen.dart';
import '../../trip_history/view/trip_history_screen.dart';
import '../../driver_earning/view/driver_earning_screen.dart';
import '../../driver_profile/view/driver_profile_screen.dart';

/// الهيكل الرئيسي للتطبيق بعد تسجيل الدخول.
/// يعرض التبويبات الأساسية عبر شريط تنقّل سفلي (Bottom Navigation).
/// نستخدم IndexedStack حتى تحتفظ كل صفحة بحالتها عند التنقّل بينها.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),      // الرئيسية
    TripHistoryScreen(),    // رحلاتي
    DriverEarningsScreen(), // الأرباح
    DriverProfileScreen(),  // حسابي
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(index: _index, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          backgroundColor: AppColors.cardWhite,
          indicatorColor: AppColors.accent.withValues(alpha: 0.25),
          height: 66,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
              label: 'رحلاتي',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet, color: AppColors.primary),
              label: 'الأرباح',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
