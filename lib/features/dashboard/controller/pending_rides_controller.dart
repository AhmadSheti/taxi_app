import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/pending_ride_model.dart';

class PendingRidesController extends GetxController {
  bool isLoading = false;
  List<PendingRideModel> pendingRides = [];

  Future<void> fetchPendingRides() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.pendingRides,
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (data) {
        final List list = data['data'] ?? [];
        pendingRides = list.map((e) => PendingRideModel.fromJson(e)).toList();
        update();
      },
    );
  }
}
