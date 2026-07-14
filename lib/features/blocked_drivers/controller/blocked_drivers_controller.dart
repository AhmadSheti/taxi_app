import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

/// كنترولر قائمة السائقين المحظورين: جلب + إلغاء الحظر.
class BlockedDriversController extends GetxController {
  bool isLoading = false;
  List<Map<String, dynamic>> blocked = [];

  Future<void> fetchBlocked() async {
    isLoading = true;
    update();
    final res = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.blocks,
    );
    isLoading = false;
    res.fold((_) {}, (data) {
      final List list = data['data'] ?? [];
      blocked = list.map((e) => Map<String, dynamic>.from(e)).toList();
    });
    update();
  }

  Future<void> unblock(int driverId) async {
    final res = await ApiService.instance.makeRequest(
      method: ApiMethod.delete,
      endPoint: EndPoints.unblock(driverId),
    );
    res.fold(
      (error) => Get.snackbar('خطأ', error,
          backgroundColor: Colors.red.shade100, snackPosition: SnackPosition.BOTTOM),
      (_) {
        Get.snackbar('تم', 'أُلغي الحظر',
            backgroundColor: Colors.green.shade100, snackPosition: SnackPosition.BOTTOM);
        fetchBlocked();
      },
    );
  }
}
