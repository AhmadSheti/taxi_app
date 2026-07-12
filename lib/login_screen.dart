 import 'package:flutter/material.dart';
import 'register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fa), // الخلفية الفاتحة حسب التصميم
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // الشعار الصغير فوق على اليمين متل الصورة
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xff0d3e46),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'م',
                      style: TextStyle(
                        fontSize: 22, 
                        color: Color(0xfffbc02d), 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // العناوين
              const Text(
                'أهلاً يا كابتن 🚕',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xff0d3e46),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'سجل دخولك وابدأ يومك، آلاف الزبائن بانتظارك.',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // حقل رقم الهاتف
              const Text(
                'رقم الهاتف',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff0d3e46)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'ادخل رقم الهاتف',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور:
               const Text(
                'كلمة المرور',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff0d3e46)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.right,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  labelText: 'ادخل كلمة المرور',
                    alignLabelWithHint: true,
                  prefixIcon: IconButton(
                    icon: Icon(_isObscured ? Icons.lock_outline : Icons.lock_open, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              
              // نسيت كلمة المرور
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // زر تسجيل الدخول الأصفر العريض
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("الرجاء إدخال رقم الهاتف وكلمة المرور"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                      // الانتقال لشاشة التالية بعد تسجيل الدخول
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const RegisterScreen()),
  );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfffbc02d), // الأصفر الخردلي
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // رابط إنشاء حساب جديد
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // سنربطه بشاشة الـ Register لاحقاً
                    },
                    child: const Text(
                      'قدّم طلباً',
                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text('لست سائقاً مسجلاً؟', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}