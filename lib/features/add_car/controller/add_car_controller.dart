import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_service.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_constants.dart';
import '../../main/view/main_shell.dart';

/// كنترولر شاشة "إضافة سيارة" (بأسلوب GetBuilder).
/// المتغيّرات عادية بدون .obs، ونستدعي update() عند تغيّرها.
class AddCarController extends GetxController {
  // حقول الإدخال النصّية
  final plateController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();

  // صورة السيارة (اختيارية، جزء من التصميم فقط)
  File? carImage;

  // أنواع السيارات القادمة من السيرفر + النوع المختار
  List<dynamic> carTypes = [];
  int? selectedCarTypeId;

  // حالة التحميل: عند true نُظهر دائرة تحميل ونعطّل الزر.
  bool isLoading = false;

  @override
  void onClose() {
    plateController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    super.onClose();
  }

  // اختيار نوع السيارة من القائمة.
  void selectCarType(int? id) {
    selectedCarTypeId = id;
    update();
  }

  /// جلب أنواع السيارات من السيرفر.
  Future<void> loadCarTypes() async {
    isLoading = true;
    update();

    final result = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.carTypes,
    );

    isLoading = false;

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        final list = data['data'];
        if (list is List) {
          carTypes = list;
          // اختيار أول نوع افتراضياً إن وُجد.
          if (carTypes.isNotEmpty) {
            selectedCarTypeId = carTypes.first['id'] as int?;
          }
        }
      },
    );

    update();
  }

  /// إرسال بيانات السيارة الجديدة للسيرفر.
  Future<void> submit() async {
    // التحقق من الحقول قبل الإرسال.
    if (selectedCarTypeId == null) {
      Get.snackbar(
        'خطأ',
        'الرجاء اختيار نوع السيارة',
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final plate = plateController.text.trim();
    final brand = brandController.text.trim();
    final model = modelController.text.trim();
    final color = colorController.text.trim();
    final year = int.tryParse(yearController.text.trim());

    if (plate.isEmpty ||
        brand.isEmpty ||
        model.isEmpty ||
        color.isEmpty ||
        year == null) {
      Get.snackbar(
        'خطأ',
        'الرجاء تعبئة جميع الحقول بشكل صحيح',
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading = true;
    update(); // أظهر التحميل

    final result = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.car,
      body: {
        'car_type_id': selectedCarTypeId,
        'plate_number': plate,
        'brand': brand,
        'model': model,
        'manufacturing_year': year,
        'color': color,
      },
    );

    isLoading = false;
    update(); // أخفِ التحميل

    result.fold(
      (error) => Get.snackbar(
        'خطأ',
        error,
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) {
        Get.snackbar(
          'تم',
          'تمت إضافة السيارة',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
        // انتهى التسجيل → ننتقل للهيكل الرئيسي.
        Get.offAll(() => const MainShell());
      },
    );
  }
}
