import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
class AvailabilityController extends GetxController {
  bool isLoading = false;
  bool isOnline = true;

  Future<void> toggleAvailability() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.availability,
      body: {
        'availability': isOnline ? 'offline' : 'online',
      },
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        isOnline = !isOnline;
        update();
      },
    );
  }
}
