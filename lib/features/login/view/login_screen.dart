import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../core/widgets/app_logo.dart';
import '../controller/login_controller.dart';
import '../../register/view/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الكنترولر محقون مسبقاً في main (AppBinding)، لذا نستدعيه فقط بـ Get.find.
    final controller = Get.find<LoginController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(child: AppLogo(size: 100)),
                  const SizedBox(height: 30),
                  const Text('تسجيل دخول السائق',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 8),
                  const Text('أدخل رقم هاتفك وكلمة المرور للمتابعة.',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 32),

                  // حقل رقم الهاتف — مربوط بـ controller.phoneController
                  const Text('رقم الهاتف',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    decoration: _inputDecoration('09xxxxxxxx', Icons.phone_outlined),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 20),

                  // حقل كلمة المرور — مربوط بـ controller.passwordController
                  const Text('كلمة المرور',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: true,
                    textAlign: TextAlign.right,
                    decoration: _inputDecoration('••••••••', Icons.lock_outline),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'رجاءً أدخل كلمة المرور' : null,
                  ),
                  const SizedBox(height: 32),

                  // زر تسجيل الدخول.
                  // GetBuilder يعيد بناء الزر فقط عندما نستدعي update() في الكنترولر.
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: GetBuilder<LoginController>(
                      builder: (c) => ElevatedButton(
                        onPressed: c.isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  c.login();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: c.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('تسجيل الدخول',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // رابط الانتقال لإنشاء حساب جديد
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟ ',
                          style: TextStyle(color: AppColors.textGrey)),
                      GestureDetector(
                        onTap: () => Get.to(() => const RegisterScreen()),
                        child: const Text('أنشئ حساباً الآن',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // تنسيق موحّد لحقول الإدخال (حتى لا نكرّره).
  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
