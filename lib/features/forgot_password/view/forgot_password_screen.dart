import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final formKey = GlobalKey<FormState>();

  // ثوابت الألوان الرسمية لتطبيق مشوار
  final Color primaryTeal = const Color(0xFF0F4C5C); // اللون الأساسي
  final Color accentGold = const Color(0xFFFFB627); // لون الأزرار والتنبيهات
  final Color darkText = const Color(0xFF1A1A2E); // لون النصوص الرئيسية
  final Color bgLight = const Color(0xFFF8F9FA); // لون الخلفية الهادئة

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم اللغة العربية بالكامل RTL
      child: Scaffold(
        backgroundColor: bgLight,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: primaryTeal),
            onPressed: () {
              Navigator.pop(context); // العودة للشاشة السابقة (Login)
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // أيقونة حماية علوية معبرة
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryTeal.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 80,
                      color: primaryTeal,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // العنوان الرئيسي
                  Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontFamily: 'Cairo', // الخط المعتمد للمشروع
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // النص التوضيحي بنبرة ودودة وموجزة
                  Text(
                    'لا تقلق يا صديقي! أدخل رقم هاتفك المسجّل وسنقوم بإرسال رمز التحقق لإعادة تعيين كلمة المرور الخاصة بك.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: darkText.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // حقل إدخال رقم الهاتف
                  TextFormField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                    decoration: _buildInputDecoration(
                      hint: 'أدخل رقم الهاتف (مثال: ٠٩٣XXXXXXX)',
                      icon: Icons.phone_android_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف أولاً';
                      }
                      if (value.length < 9) {
                        return 'الرجاء إدخال رقم هاتف صحيح';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // زر إرسال الرمز الرئيسي باللون الذهبي
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: GetBuilder<ForgotPasswordController>(
                      builder: (c) => ElevatedButton(
                        onPressed: c.isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  c.sendResetCode();
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGold,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: c.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'إرسال رمز التحقق',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkText,
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
      ),
    );
  }

  // دالة بناء التصميم الداخلي للحقل للحفاظ على نظافة الكود وهويته البصرية
  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14,
        fontFamily: 'Cairo',
      ),
      prefixIcon: Icon(icon, color: primaryTeal),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: primaryTeal,
          width: 2,
        ), // اللون الفيروزي عند التفاعل
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE63946),
          width: 1,
        ), // لون التحذير الرسمي
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE63946), width: 2),
      ),
    );
  }
}
