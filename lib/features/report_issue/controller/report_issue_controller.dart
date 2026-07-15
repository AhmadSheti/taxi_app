import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

/// كنترولر الإبلاغ عن مشكلة (عن سائق في رحلة معيّنة).
class ReportIssueController extends GetxController {
  bool isSending = false;

  Future<bool> submit({
    required int reportedId,
    int? rideId,
    required String description,
  }) async {
    isSending = true;
    update();

    final res = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.reports,
      body: {
        'reported_id': reportedId,
        if (rideId != null) 'ride_id': rideId,
        'description': description,
      },
    );

    isSending = false;
    update();

    bool ok = false;
    res.fold(
      (error) => Get.snackbar('خطأ', error,
          backgroundColor: Colors.red.shade100, snackPosition: SnackPosition.BOTTOM),
      (_) => ok = true,
    );
    return ok;
  }
}
