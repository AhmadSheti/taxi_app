import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RegisterController());
    final formKey = GlobalKey<FormState>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.textMain,
          title: const Text('إنشاء حساب',
              style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('أنشئ حسابك خلال دقيقة وابدأ رحلتك.',
                      style: AppStyles.bodyRegular),
                  const SizedBox(height: 24),
                  _field(c.nameController, 'الاسم الكامل', Icons.person_outline),
                  _field(c.emailController, 'البريد الإلكتروني', Icons.email_outlined,
                      keyboard: TextInputType.emailAddress),
                  _field(c.phoneController, 'رقم الهاتف', Icons.phone_outlined,
                      keyboard: TextInputType.phone),
                  _field(c.passwordController, 'كلمة المرور', Icons.lock_outline,
                      obscure: true),
                  _field(c.confirmController, 'تأكيد كلمة المرور', Icons.lock_outline,
                      obscure: true,
                      validator: (v) => v != c.passwordController.text
                          ? 'كلمتا المرور غير متطابقتين'
                          : null),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: GetBuilder<RegisterController>(
                      builder: (ctrl) => ElevatedButton(
                        onPressed: ctrl.isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) ctrl.register();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryAmber,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: ctrl.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('إنشاء الحساب', style: AppStyles.buttonText),
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

  Widget _field(TextEditingController controller, String label, IconData icon,
      {bool obscure = false,
      TextInputType? keyboard,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        textAlign: TextAlign.right,
        validator: validator ??
            (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          prefixIcon: Icon(icon, color: AppColors.primaryTeal),
          filled: true,
          fillColor: AppColors.cardWhite,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5)),
        ),
      ),
    );
  }
}
