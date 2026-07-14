import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constants.dart';
import 'core/app_binding.dart';
import 'features/splash/view/splash_screen.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MishwarApp());
}

class MishwarApp extends StatelessWidget {
  const MishwarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'مشوار - Mishwar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppStyles.fontFamily,
        primaryColor: AppColors.primaryTeal,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryTeal,
          primary: AppColors.primaryTeal,
          secondary: AppColors.secondaryAmber,
        ),
        useMaterial3: true,
      ),
      // كل الـ Controllers المشتركة تُحقن هنا مرة واحدة.
      initialBinding: AppBinding(),
      // نفرض اتجاه RTL على كامل التطبيق (يشمل الحوارات والتنبيهات).
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const SplashScreen(),
    );
  }
}
