import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../core/storage/app_storage.dart';
import '../../../core/widgets/app_logo.dart';
import '../../active_trip/view/active_trip_screen.dart';
import '../../dashboard/controller/pending_rides_controller.dart';
import '../../live_trip/view/live_trip_screen.dart';
import '../../login/view/login_screen.dart';
import '../../main/view/main_shell.dart';
import '../../ride_request/controller/ride_request_controller.dart';
import '../../waiting_customer/view/waiting_customer_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // بعد ثانيتين: نحدّد الوجهة حسب حالة السائق.
    Timer(const Duration(seconds: 2), _decideStart);
  }

  Future<void> _decideStart() async {
    if (!AppStorage.isLoggedIn) {
      Get.offAll(() => const LoginScreen());
      return;
    }

    // مسجّل دخول: نتحقق إن كان لديه رحلة نشطة لنستأنفها للشاشة الصحيحة.
    final ride = await Get.find<RideRequestController>().fetchActiveRide();

    Get.offAll(() => const MainShell());

    if (ride != null) {
      // نوقف استطلاع الطلبات المتاحة (السائق مشغول برحلة).
      Get.find<PendingRidesController>().pauseForTrip();

      final Widget? screen = switch (ride.status) {
        'accepted' => const ActiveTripScreen(),       // في الطريق للزبون → زر "وصلت"
        'driver_arrived' => const WaitingCustomerScreen(), // وصل → زر "بدء الرحلة"
        'in_progress' => const LiveTripScreen(),       // الرحلة جارية → زر "إنهاء"
        _ => null,
      };
      if (screen != null) Get.to(() => screen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 130),
            const SizedBox(height: 20),
            const Text(
              'مشوار',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            const Text(
              'DRIVER • السائقين',
              style: TextStyle(
                  fontSize: 14, color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
