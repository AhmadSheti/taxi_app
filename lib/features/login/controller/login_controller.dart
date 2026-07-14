import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/features/main/view/main_shell.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../model/user_model.dart';

/// كنترولر تسجيل الدخول (بأسلوب GetBuilder).
/// المتغيّرات عادية بدون .obs، ونستدعي update() عند تغيّرها.
class LoginController extends GetxController {
  // حقول الإدخال (السائق يسجّل برقم الهاتف)
  final phoneController = TextEditingController();
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
        'phone': phoneController.text.trim(),
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
        // شكل الرد: { "success": true, "data": { "token": "...", "user": {...} } }
        // إذن التوكن داخل data['data'] وليس في المستوى الأعلى.
        final payload = (data is Map && data['data'] is Map)
            ? Map<String, dynamic>.from(data['data'])
            : Map<String, dynamic>.from(data);

        final token = payload['token'] ?? payload['access_token'];
        if (token == null) {
          Get.snackbar('خطأ', 'لم يصل التوكن من السيرفر',
              backgroundColor: Colors.red.shade100,
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
        await AppStorage.saveToken(token.toString());

        if (payload['user'] != null) {
          user = UserModel.fromJson(Map<String, dynamic>.from(payload['user']));
        }

        // ننتقل للهيكل الرئيسي (شريط التنقّل السفلي).
        Get.offAll(() => const MainShell());
      },
    );
  }
}
