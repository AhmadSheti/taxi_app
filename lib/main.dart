import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MishwarDriverApp());
}

class MishwarDriverApp extends StatelessWidget {
  const MishwarDriverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مشوار سائق',
      theme: ThemeData(
        // إعدادات الألوان حسب التصميم
        primaryColor: const Color(0xff0d3e46), // اللون الزيتي الغامق
        scaffoldBackgroundColor: const Color(0xfff7f9fa), // الخلفية الفاتحة للتطبيق
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xfffbc02d), // اللون الأصفر الخردلي للأزرار
        ),
      ),
      home:SplashScreen(), // البداية من شاشة الـ Splash
    );
  }
}