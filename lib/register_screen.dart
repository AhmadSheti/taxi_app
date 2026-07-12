import 'package:flutter/material.dart';
import 'constants.dart'; // استدعاء ملف الثوابت الخاص بك بدقة
import 'login_screen.dart'; // للتمكن من العودة لشاشة تسجيل الدخول
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // تعريف وحدات التحكم بالحقول لجمع البيانات لاحقاً
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Directionality(
            textDirection: TextDirection
                .rtl, // دعم الواجهة العربية بالكامل من اليمين لليسار
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // زر العودة للخلف في أعلى الشاشة
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primaryTeal,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // شعار تطبيق مشوار الدائري المصغر
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryTeal,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'م',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryAmber,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'مشوار',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // نصوص الترحيب والعناوين
                  const Text('إنشاء حساب جديد', style: AppStyles.headingBold),
                  const SizedBox(height: 8),
                  const Text(
                    'أدخل بياناتك لتبدأ مشوارك معنا وتستمتع برحلات آمنة.',
                    style: AppStyles.bodyRegular,
                  ),
                  const SizedBox(height: 28),

                  // حقل الاسم الكامل
                  const Text(
                    'الاسم الكامل',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.right,
                    decoration: _buildInputDecoration(
                      'أدخل اسمك الثلاثي',
                      Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'هذا الحقل مطلوب';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // حقل البريد الإلكتروني
                  const Text(
                    'البريد الإلكتروني',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,
                    decoration: _buildInputDecoration(
                      'example@mail.com',
                      Icons.email_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'هذا الحقل مطلوب';
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // حقل رقم الهاتف
                  const Text(
                    'رقم الهاتف',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    decoration: _buildInputDecoration(
                      '09xxxxxxxx',
                      Icons.phone_android_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'هذا الحقل مطلوب';
                      if (value.length < 10) return 'رقم الهاتف غير مكتمل';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // حقل كلمة المرور
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
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.cardWhite,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryTeal,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
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
                        borderSide: const BorderSide(
                          color: AppColors.primaryTeal,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'رجاءً أدخل كلمة المرور';
                      if (value.length < 6)
                        return 'يجب أن تكون كلمة المرور 6 خانات على الأقل';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // زر إنشاء الحساب الرئيسي (باللون الذهبي)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                  phoneNumber: _phoneController.text,
                                ),
                              ),
                            );
                          }
                          // هنا سنقوم بربط شاشة التحقق OTP في الخطوة القادمة
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('جاري معالجة البيانات...'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryAmber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'إنشاء الحساب',
                        style: AppStyles.buttonText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // الانتقال السريع لشاشة تسجيل الدخول إذا كان يملك حساباً
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'لديك حساب بالفعل؟ ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'سجّل الدخول',
                          style: TextStyle(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  // دالة مساعدة لبناء الـ InputDecoration المشترك لتقليل تكرار الأكواد
  InputDecoration _buildInputDecoration(String hint, IconData icon) {
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
