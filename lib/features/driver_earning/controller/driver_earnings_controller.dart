import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/driver_earnings_chart_model.dart';
import '../model/driver_earnings_summary_model.dart';

class DriverEarningsController extends GetxController {
  bool isLoading = false;
  DriverEarningsSummaryModel? summary;
  List<DriverEarningsChartModel> chartData = [];

  Future<void> fetchEarningsSummary(String period) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '${EndPoints.earningsSummary}?period=$period',
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
        if (data is Map<String, dynamic>) {
          summary = DriverEarningsSummaryModel.fromJson(data);
        } else if (data is Map) {
          summary = DriverEarningsSummaryModel.fromJson(Map<String, dynamic>.from(data));
        } else {
          summary = null;
        }
        update();
      },
    );
  }

  Future<void> fetchEarningsChart(String period) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '${EndPoints.earningsChart}?period=$period',
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
        if (data is Map<String, dynamic>) {
          final list = data['data'];
          if (list is List) {
            chartData = list
                .map((item) => DriverEarningsChartModel.fromJson(Map<String, dynamic>.from(item)))
                .toList();
          } else {
            chartData = [];
          }
        } else if (data is List) {
          chartData = data
              .map((item) => DriverEarningsChartModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        } else {
          chartData = [];
        }
        update();
      },
    );
  }
}
