import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../../home/view/home_shell.dart';
import '../model/user_model.dart';

/// كنترولر تسجيل الدخول (بأسلوب GetBuilder).
/// المتغيّرات عادية بدون .obs، ونستدعي update() عند تغيّرها.
class LoginController extends GetxController {
  // حقل واحد يقبل رقم الهاتف أو البريد.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  UserModel? user;

  Future<void> login() async {
    isLoading = true;
    update();

    // الـ backend يقبل الهاتف أو البريد في حقل phone.
    final result = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.login,
      body: {
        'phone': emailController.text.trim(),
        'password': passwordController.text,
      },
    );

    isLoading = false;
    update();

    result.fold(
      (error) => Get.snackbar('خطأ', error,
          backgroundColor: Colors.red.shade100, snackPosition: SnackPosition.BOTTOM),
      (data) async {
        // شكل الرد: { success, message, data: { token, user } }
        final payload = data['data'] ?? {};
        final token = payload['token'];
        if (token != null) {
          await AppStorage.saveToken(token.toString());
          if (payload['user'] != null) {
            user = UserModel.fromJson(payload['user']);
          }
          Get.offAll(() => const HomeShell());
        }
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
