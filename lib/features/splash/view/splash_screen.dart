import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../core/storage/app_storage.dart';
import '../../../core/widgets/app_logo.dart';
import '../../booking/controller/booking_controller.dart';
import '../../booking/view/tracking_screen.dart';
import '../../home/view/home_shell.dart';
import '../../welcome/view/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // بعد ثانيتين: نحدّد الوجهة حسب حالة المستخدم.
    Timer(const Duration(seconds: 2), _decideStart);
  }

  Future<void> _decideStart() async {
    // غير مسجّل دخول → شاشة الترحيب.
    if (!AppStorage.isLoggedIn) {
      Get.offAll(() => const WelcomeScreen());
      return;
    }

    // مسجّل دخول: نتحقق إن كان لديه رحلة نشطة لنستأنفها.
    final rideId = await Get.find<BookingController>().fetchActiveRide();

    if (rideId != null) {
      // نفتح الرئيسية ثم ننتقل لشاشة التتبّع (فالرجوع يعود للرئيسية).
      Get.offAll(() => const HomeShell());
      Get.to(() => TrackingScreen(rideId: rideId));
    } else {
      Get.offAll(() => const HomeShell());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 130),
            const SizedBox(height: 16),
            const Text('مشوار',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal)),
            const SizedBox(height: 4),
            const Text('رفيق طريقك', style: AppStyles.bodyRegular),
          ],
        ),
      ),
    );
  }
}
