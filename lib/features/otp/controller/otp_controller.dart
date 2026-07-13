import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:new_app/features/home/view/home_screen.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../../login/model/user_model.dart';

/// كنترولر التحقق من OTP (بأسلوب GetBuilder).
class OtpController extends GetxController {
  // حقول الإدخال
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  // حالة التحميل
  bool isLoading = false;

  // بيانات المستخدم بعد التحقق الناجح
  UserModel? user;

  // مؤقت إعادة الإرسال
  late Timer _timer;
  int secondsRemaining = 60;
  bool canResend = false;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  /// بدء المؤقت التنازلي لإعادة الإرسال
  void startTimer() {
    secondsRemaining = 60;
    canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        canResend = true;
        _timer.cancel();
      } else {
        secondsRemaining--;
      }
      update();
    });
  }

  /// التحقق من OTP
  Future<void> verifyOtp() async {
    if (phoneController.text.isEmpty || otpController.text.isEmpty) {
      Get.snackbar(
        'تحذير',
        'أدخل رقم الهاتف والكود',
        backgroundColor: Colors.orange.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading = true;
    update();

    // نرسل الطلب للسيرفر
    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.verifyOtp,
      body: {
        'phone': phoneController.text.trim(),
        'code': otpController.text.trim(),
      },
    );

    isLoading = false;
    update();

    // معالجة الرد
    result.fold(
      (error) => Get.snackbar(
        'خطأ',
        error,
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) async {
        // استخراج البيانات من الرد
        final responseData = data['data'] ?? data;
        final token = responseData['token'];

        // حفظ الـ token
        await AppStorage.saveToken(token.toString());

        // حفظ بيانات المستخدم
        if (responseData['user'] != null) {
          user = UserModel.fromJson(responseData['user']);
        }

        // عرض رسالة النجاح
        Get.snackbar(
          'نجح',
          'تم التحقق من الكود بنجاح',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );

        // الانتقال لشاشة البيت
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAll(() => const HomeScreen());
      },
    );
  }

  /// إعادة إرسال الكود
  void resendOtp() {
    if (!canResend) {
      Get.snackbar(
        'تحذير',
        'يرجى الانتظار ${secondsRemaining}ث',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    startTimer();
    Get.snackbar(
      'تم',
      'تم إرسال الكود إلى ${phoneController.text}',
      backgroundColor: Colors.green.shade100,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.onClose();
  }
}
