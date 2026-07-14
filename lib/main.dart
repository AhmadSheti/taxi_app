import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constants.dart';
import 'core/app_binding.dart';
import 'features/splash/view/splash_screen.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MishwarDriverApp());
}

class MishwarDriverApp extends StatelessWidget {
  const MishwarDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp (بدل MaterialApp) لتفعيل تنقّل GetX.
    return GetMaterialApp(
      title: 'مشوار سائق',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.accent,
        ),
      ),
      // كل الـ Controllers تُحقن هنا مرة واحدة عند بدء التطبيق.
      initialBinding: AppBinding(),
      // نبدأ دائماً من Splash، وهي تقرّر الوجهة حسب حالة تسجيل الدخول.
      home: const SplashScreen(),
    );
  }
}
