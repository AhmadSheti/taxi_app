import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/features/add_car/view/add%20_car_screen.dart';
import 'package:new_app/features/dashboard/view/dashbord_screen.dart';
import 'package:new_app/features/login/model/user_model.dart';
import 'package:new_app/features/otp/view/otp_screen.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../../notifications/view/notifications_screen.dart';

/// كنترولر تسجيل الدخول (بأسلوب GetBuilder).
/// المتغيّرات عادية بدون .obs، ونستدعي update() عند تغيّرها.
class AddCarController extends GetxController {
  // حقول الإدخال (السائق يسجّل برقم الهاتف)
  final cartypeController = TextEditingController();
  final plateController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final ColorController = TextEditingController();
  final brandController = TextEditingController();
    File? carImage;

  // حالة التحميل: عند true نُظهر دائرة تحميل ونعطّل الزر.
  bool isLoading = false;

  // بيانات المستخدم بعد نجاح الدخول (اختياري نستخدمه لاحقاً)
  UserModel? user;

  Future<void> addCar() async {
    isLoading = true;
    update(); // أظهر التحميل

    // نرسل الطلب للسيرفر عبر خدمة الاتصال الموحّدة.
    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.addCar,
      body: {
        'car_type_id': 1,
        'plate_number': plateController.text,
        'model': modelController.text,
        'year': yearController.text,
        'Color': ColorController.text,
        'image':carImage,
        'brand' : brandController.text
      },
    );

    isLoading = false;
    update(); // أخفِ التحميل

    // fold: نتعامل مع الحالتين — خطأ (Left) أو نجاح (Right).
    result.fold(
      (error) => Get.snackbar(
        'خطأ',
        error,
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) async {
        Get.offAll(() => const DashboardScreen());
      },
    );  
  }
}
