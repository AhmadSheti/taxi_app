import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/company_commission_model.dart';

class CompanyCommissionController extends GetxController {
  bool isLoading = false;
  CompanyCommissionModel? commission;

  Future<void> fetchCommission() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.earningsCommission,
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        if (data is Map<String, dynamic>) {
          commission = CompanyCommissionModel.fromJson(data);
        } else if (data is Map) {
          commission = CompanyCommissionModel.fromJson(Map<String, dynamic>.from(data));
        } else {
          commission = null;
        }
        update();
      },
    );
  }
}
