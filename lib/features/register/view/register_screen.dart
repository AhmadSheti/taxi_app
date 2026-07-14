import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الكنترولر محقون في main (AppBinding).
    final c = Get.find<RegisterController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("الخطوة ١ من ٢",
                    style: TextStyle(color: Colors.teal, fontSize: 14)),
                const SizedBox(height: 4),
                const Text("تسجيل حساب سائق",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 8),
                const LinearProgressIndicator(
                    value: 0.5, backgroundColor: Colors.black12, color: Colors.teal),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text("معلوماتك الشخصية",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E))),
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text("سنحتاج إلى توثيق هويتك قبل الموافقة.",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
                const SizedBox(height: 24),

                _buildAnimatedField(
                  labelText: "الاسم الكامل",
                  controller: c.nameController,
                  icon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "الرجاء إدخال الاسم الكامل" : null,
                ),
                _buildAnimatedField(
                  labelText: "أدخل رقم الهاتف المعتمد",
                  controller: c.phoneController,
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "الرجاء إدخال رقم الهاتف" : null,
                ),
                _buildAnimatedField(
                  labelText: "البريد الإلكتروني",
                  controller: c.emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "الرجاء إدخال البريد الإلكتروني";
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(v.trim())) {
                      return "صيغة البريد الإلكتروني غير صحيحة";
                    }
                    return null;
                  },
                ),
                _buildAnimatedField(
                  labelText: "أدخل كلمة المرور (٦ أحرف على الأقل)",
                  controller: c.passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "الرجاء إدخال كلمة المرور";
                    if (v.length < 6) return "كلمة المرور قصيرة جداً";
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // الزر مربوط بـ RegisterController.login() (POST /driver/register → OTP)
                GetBuilder<RegisterController>(
                  builder: (rc) => SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: rc.isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                rc.login();
                              }
                            },
                      child: rc.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("التالي · التحقق",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.black),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedField({
    required String labelText,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w500),
          floatingLabelStyle:
              const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xffF7F7F9),
          alignLabelWithHint: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
