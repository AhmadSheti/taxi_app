import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/features/home/view/home_screen.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../../notifications/view/notifications_screen.dart';
import '../model/user_model.dart';

/// كنترولر تسجيل الدخول (بأسلوب GetBuilder).
/// المتغيّرات عادية بدون .obs، ونستدعي update() عند تغيّرها.
class LoginController extends GetxController {
  // حقول الإدخال
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // حالة التحميل: عند true نُظهر دائرة تحميل ونعطّل الزر.
  bool isLoading = false;

  // بيانات المستخدم بعد نجاح الدخول (اختياري نستخدمه لاحقاً)
  UserModel? user;

  Future<void> login() async {
    isLoading = true;
    update(); // أظهر التحميل

    // نرسل الطلب للسيرفر عبر خدمة الاتصال الموحّدة.
    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.login,
      body: {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      },
    );

    isLoading = false;
    update(); // أخفِ التحميل

    // fold: نتعامل مع الحالتين — خطأ (Left) أو نجاح (Right).
    result.fold(
      (error) => Get.snackbar('خطأ', error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM),
      (data) async {
        final token = data['token'];
        await AppStorage.saveToken(token.toString());

        if (data['user'] != null) {
          user = UserModel.fromJson(data['user']);
        }

        // ننتقل لشاشة الإشعارات (نستبدل الشاشة الحالية).
        Get.offAll(() => const HomeScreen());
      },
    );
  }
}
