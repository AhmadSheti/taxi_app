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
  runApp(const MishwarApp());
}

class MishwarApp extends StatelessWidget {
  const MishwarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp (بدل MaterialApp) لتفعيل تنقّل GetX (Get.to / Get.offAll ...).
    return GetMaterialApp(
      title: 'مشوار - Mishwar',
      debugShowCheckedModeBanner: false,
      // كل الـ Controllers تُحقن هنا مرة واحدة عند بدء التطبيق.
      initialBinding: AppBinding(),
      // إذا كان المستخدم مسجّل دخول نفتح الإشعارات مباشرة، وإلا شاشة الدخول.
      home: AppStorage.isLoggedIn
          ? const NotificationsScreen()
          : const LoginScreen(),
    );
  }
}
