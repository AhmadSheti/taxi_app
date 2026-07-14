import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_service.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_constants.dart';
import '../model/car_model.dart';

class CarDetailsController extends GetxController {
  bool isLoading = false;
  CarModel? car;

  Future<void> load() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.car,
    );

    result.fold(
      (error) {
        car = null;
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        final carData = data['data'];
        if (carData != null && carData is Map) {
          car = CarModel.fromJson(Map<String, dynamic>.from(carData));
        } else {
          car = null;
        }
      },
    );

    isLoading = false;
    update();
  }
}
