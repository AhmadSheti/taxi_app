import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../driver_profile/controller/driver_profile_controller.dart';

/// كنترولر صفحة «معلوماتي» — يحمّل بيانات السائق ويحدّثها عبر /driver/profile.
class PersonalInfoController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool isSaving = false;

  Future<void> load() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.profile,
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (res) {
        final d = res['data'];
        if (d is Map) {
          nameController.text = d['name']?.toString() ?? '';
          emailController.text = d['email']?.toString() ?? '';
          phoneController.text = d['phone']?.toString() ?? '';
        }
        update();
      },
    );
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الاسم مطلوب',
          backgroundColor: Colors.amber.shade100,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSaving = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.profile,
      body: {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
      },
    );

    isSaving = false;
    update();

    result.fold(
      (error) => Get.snackbar('خطأ', error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM),
      (_) {
        Get.snackbar('تم', 'تم تحديث بياناتك بنجاح',
            backgroundColor: Colors.green.shade100,
            snackPosition: SnackPosition.BOTTOM);
        // نحدّث تبويب «حسابي» ليعكس التغيير مباشرة.
        if (Get.isRegistered<DriverProfileController>()) {
          Get.find<DriverProfileController>().load();
        }
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
