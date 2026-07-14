import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../core/widgets/app_logo.dart';
import '../controller/login_controller.dart';

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
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'مشوار',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text('تسجيل الدخول', style: AppStyles.headingBold),
                  const SizedBox(height: 8),
                  const Text(
                    'أهلاً بك مجدداً! يرجى إدخال بياناتك للمتابعة.',
                    style: AppStyles.bodyRegular,
                  ),
                  const SizedBox(height: 32),

                  // حقل البريد الإلكتروني — مربوط بـ controller.emailController
                  const Text(
                    'البريد الإلكتروني أو رقم الهاتف',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,
                    decoration: _inputDecoration(
                      hint: 'example@mail.com أو 09xxxxxxxx',
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 20),

                  // حقل كلمة المرور — مربوط بـ controller.passwordController
                  const Text(
                    'كلمة المرور',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: true,
                    textAlign: TextAlign.right,
                    decoration: _inputDecoration(
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'رجاءً أدخل كلمة المرور' : null,
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
                          backgroundColor: AppColors.secondaryAmber,
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
                            : const Text('تسجيل الدخول', style: AppStyles.buttonText),
                      ),
                    ),
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
  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      filled: true,
      fillColor: AppColors.cardWhite,
      prefixIcon: Icon(icon, color: AppColors.primaryTeal),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
      ),
    );
  }
}
