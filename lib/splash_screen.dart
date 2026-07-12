import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // رح تنقلنا لصفحة الدخول

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    // مؤقت زمني ينقلنا بعد 3 ثواني لشاشة تسجيل الدخول
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // تصميم اللوجو المؤقت لحين رفع الصورة الحقيقية
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xff0d3e46), // اللون الزيتي
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'م',
                  style: TextStyle(fontSize: 60, color: Color(0xfffbc02d), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'مشوار',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff0d3e46)),
            ),
            const Text(
              'DRIVER • السائقين',
              style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Color(0xff0d3e46),
            ),
          ],
        ),
      ),
    );
  }
}