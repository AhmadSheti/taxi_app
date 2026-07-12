import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/app_binding.dart';
import 'core/storage/app_storage.dart';
import 'features/auth/view/login_screen.dart';
import 'features/notifications/view/notifications_screen.dart';

Future<void> main() async {
  // نُهيّئ التخزين المحلي قبل تشغيل التطبيق (ضروري لـ get_storage).
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
        primaryColor: const Color(0xff0d3e46),
        scaffoldBackgroundColor: const Color(0xfff7f9fa),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xfffbc02d),
        ),
      ),
      // كل الـ Controllers تُحقن هنا مرة واحدة عند بدء التطبيق.
      initialBinding: AppBinding(),
      // إذا كان السائق مسجّل دخول نفتح الإشعارات مباشرة، وإلا شاشة الدخول.
      home: AppStorage.isLoggedIn
          ? const NotificationsScreen()
          : const LoginScreen(),
    );
  }
}
