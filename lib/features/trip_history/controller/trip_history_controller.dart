import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/trip_history_model.dart';

class TripHistoryController extends GetxController {
  bool isLoading = false;
  List<TripHistoryModel> trips = [];
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;

  Future<void> fetchTripHistory({
    String status = 'all',
    int page = 1,
    int perPage = 20,
  }) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.tripHistory,
      queryParams: {
        'status': status,
        'page': page,
        'per_page': perPage,
      },
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
          final rawTrips = data['data'];
          if (rawTrips is List) {
            trips = rawTrips
                .map((item) => TripHistoryModel.fromJson(Map<String, dynamic>.from(item)))
                .toList();
          } else {
            trips = [];
          }

          final pagination = data['pagination'];
          if (pagination is Map<String, dynamic>) {
            currentPage = pagination['current_page'] is int
                ? pagination['current_page']
                : int.tryParse(pagination['current_page']?.toString() ?? '') ?? 1;
            lastPage = pagination['last_page'] is int
                ? pagination['last_page']
                : int.tryParse(pagination['last_page']?.toString() ?? '') ?? 1;
            total = pagination['total'] is int
                ? pagination['total']
                : int.tryParse(pagination['total']?.toString() ?? '') ?? 0;
          }
        } else {
          trips = [];
          currentPage = 1;
          lastPage = 1;
          total = 0;
        }
        update();
      },
    );
  }
}
