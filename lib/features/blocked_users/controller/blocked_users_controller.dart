import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_service.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_constants.dart';
import '../model/blocked_user_model.dart';

// كنترولر شاشة المستخدمين المحظورين.
// يستخدم GetBuilder + update() (بدون .obs / Obx).
class BlockedUsersController extends GetxController {
  bool isLoading = false;
  List<BlockedUserModel> users = [];

  // جلب قائمة المحظورين من السيرفر.
  Future<void> load() async {
    isLoading = true;
    update();

    final result = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.blocks,
    );

    result.fold(
      (error) {
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (data) {
        final List list = (data['data'] ?? []) as List;
        users = list
            .map((e) => BlockedUserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    isLoading = false;
    update();
  }

  // إلغاء حظر مستخدم ثم إعادة تحميل القائمة عند النجاح.
  Future<void> unblock(int customerId) async {
    final result = await ApiService().makeRequest(
      method: ApiMethod.delete,
      endPoint: '${EndPoints.blocks}/$customerId',
    );

    result.fold(
      (error) {
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (data) {
        Get.snackbar('تم', 'تم إلغاء الحظر',
            backgroundColor: Colors.green.shade100,
            snackPosition: SnackPosition.BOTTOM);
        load();
      },
    );
  }
}
