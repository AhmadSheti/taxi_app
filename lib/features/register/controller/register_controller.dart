import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/features/add_car/view/add%20_car_screen.dart';
import 'package:new_app/features/login/model/user_model.dart';
import 'package:new_app/features/otp/view/otp_screen.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';

/// كنترولر تسجيل الدخول (بأسلوب GetBuilder).
/// المتغيّرات عادية بدون .obs، ونستدعي update() عند تغيّرها.
class RegisterController extends GetxController {
  // حقول الإدخال (السائق يسجّل برقم الهاتف)
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController=TextEditingController(); 
   final emailController=TextEditingController(); 
  // حالة التحميل: عند true نُظهر دائرة تحميل ونعطّل الزر.
  bool isLoading = false;

  // بيانات المستخدم بعد نجاح الدخول (اختياري نستخدمه لاحقاً)
  UserModel? user;

  Future<void> login() async {
    isLoading = true;
    update(); // أظهر التحميل

    // نرسل الطلب للسيرفر عبر خدمة الاتصال الموحّدة.
    final result = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.register,
      body: {
        'name': nameController.text,
        'email': emailController.text,
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
        Get.offAll(() => OtpScreen(phone: phoneController.text.trim()));
      },
    );
  }

  Future<void> verifyOtp(String phone, String code) async {
    if (code.length != 6) {
      Get.snackbar(
        'خطأ',
        'ادخل جميع أرقام الرمز',
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading = true;
    update();

    final result = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.verifyOtp,
      body: {
        'phone': phone,
        'code': code,
      },
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
        // التوكن داخل data['data'] (شكل الرد الموحّد).
        final payload = (data is Map && data['data'] is Map)
            ? Map<String, dynamic>.from(data['data'])
            : Map<String, dynamic>.from(data);
        final token = payload['token'] ?? payload['access_token'];
        if (token != null) {
          await AppStorage.saveToken(token.toString());
        }
        Get.offAll(() => const AddCarScreen());
      },
    );
  }


}
