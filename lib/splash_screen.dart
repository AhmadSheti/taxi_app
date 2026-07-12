import 'dart:async';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'onboarding_screen.dart'; // سننشئها في الخطوة التالية

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال التلقائي بعد 3 ثوانٍ إلى شاشات التقديم
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal, // اللون الأساسي من الثوابت
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق (مربع ذهبي بداخله حرف م)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.secondaryAmber, // اللون الذهبي
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text(
                  'م',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // اسم التطبيق
            const Text(
              'مشوار',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // الشعار اللفظي المعتمد في التصميم
            const Text(
              'M I S H W A R · رفيق طريقك',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryAmber,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}