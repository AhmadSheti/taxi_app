import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../../home/view/home_shell.dart';

/// كنترولر إنشاء الحساب. عند النجاح يحفظ التوكن وينتقل للشاشة الرئيسية.
class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    isLoading = true;
    update();

    final res = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.register,
      body: {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': confirmController.text,
      },
    );

    isLoading = false;
    update();

    res.fold(
      (error) => Get.snackbar('خطأ', error,
          backgroundColor: Colors.red.shade100, snackPosition: SnackPosition.BOTTOM),
      (data) async {
        final token = data['data']?['token'];
        if (token != null) {
          await AppStorage.saveToken(token.toString());
          Get.offAll(() => const HomeShell());
        }
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
