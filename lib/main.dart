import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MishwarApp());
}

class MishwarApp extends StatelessWidget {
  const MishwarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'مشوار - Mishwar',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // البداية من شاشة الـ Splash
    );
  }
}