import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants.dart'; // استدعاء ملف الثوابت الخاص بك

class OtpScreen extends StatefulWidget {
  final String phoneNumber; // لتمرير وعرض رقم هاتف المستخدم في الواجهة
  
  const OtpScreen({super.key, this.phoneNumber = '09xxxxxxxx'});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // وحدات التحكم بالحقول الأربعة لرمز الـ OTP
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  
  // متغيرات المؤقت التنازلي لإعادة إرسال الرمز
  late Timer _timer;
  int _startSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _startSeconds = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() {
          _canResend = true;
          _timer.cancel();
        });
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // دالة تجميع الرمز الكامل للتحقق منه
  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Directionality(
            textDirection: TextDirection.rtl, // دعم الواجهة العربية بالكامل
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // زر العودة للخلف
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: AppColors.primaryTeal, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 40),

                // عنوان الشاشة
                const Text(
                  'رمز التحقق',
                  style: AppStyles.headingBold,
                ),
                const SizedBox(height: 12),
                
                // نص إرشادي ودود مع رقم الهاتف
                Text(
                  'أدخل رمز التحقق المكون من 4 أرقام والذي أرسلناه إلى الرقم ${widget.phoneNumber}',
                  style: AppStyles.bodyRegular,
                ),
                const SizedBox(height: 48),

                // صف مربعات إدخال الـ OTP الأربعة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _buildOtpTextField(index)),
                ),
                const SizedBox(height: 32),

                // قسم المؤقت التنازلي وإعادة الإرسال
                Center(
                  child: _canResend
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('لم يصلك الرمز؟ ', style: TextStyle(color: AppColors.textSecondary)),
                            GestureDetector(
                              onTap: () {
                                _startTimer();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تم إعادة إرسال الرمز بنجاح.')),
                                );
                              },
                              child: const Text(
                                'إعادة إرسال',
                                style: TextStyle(
                                  color: AppColors.primaryTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'إعادة إرسال الرمز خلال $_startSeconds ثانية',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                ),
                const SizedBox(height: 48),

                // زر التأكيد الرئيسي باللون الذهبي المميز للتطبيق
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      String code = _getOtpCode();
                      if (code.length == 4) {
                        // هنا سيتم توجيه المستخدم مستقبلاً للشاشة الرئيسية للتطبيق (Home)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم التحقق بنجاح بالرمز: $code')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('يرجى إدخال الرمز كاملاً المكون من 4 أرقام')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryAmber,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'تأكيد وتفعيل الحساب',
                      style: AppStyles.buttonText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // بناء حقل الـ OTP المفرد مع تفعيل الانتقال التلقائي الذكي
  Widget _buildOtpTextField(int index) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1), // رقم واحد فقط لكل حقل
          FilteringTextInputFormatter.digitsOnly, // أرقام فقط
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.cardWhite,
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2.0),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // الانتقال التلقائي للحقل التالي إذا لم نكن في الحقل الأخير
            if (index < 3) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              _focusNodes[index].unfocus(); // إغلاق لوحة المفاتيح عند كتابة الحقل الأخير
            }
          } else {
            // العودة التلقائية للحقل السابق عند المسح (Backspace)
            if (index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          }
        },
      ),
    );
  }
}