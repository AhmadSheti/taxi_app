import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/features/otp/view/otp_screen.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> sendResetCode() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar(
        'تحذير',
        'أدخل رقم الهاتف أولاً',
        backgroundColor: Colors.orange.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.forgotPassword,
      body: {'phone': phone},
    );

    isLoading = false;
    update();

    result.fold(
      (error) => Get.snackbar(
        'خطأ',
        error,
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) async {
        final message = data['message']?.toString() ?? 'تم إرسال رمز التحقق';

        Get.snackbar(
          'نجح',
          message,
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.to(() => OtpScreen(phoneNumber: phone));
      },
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
