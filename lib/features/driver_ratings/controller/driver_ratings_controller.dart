import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/rating_model.dart';

class DriverRatingsController extends GetxController {
  bool isLoading = false;

  /// ملخّص التقييمات (المتوسط، العدد الكلي، توزيع النجوم).
  RatingsSummaryModel? summary;

  /// قائمة التقييمات الفردية.
  List<RatingModel> ratings = [];

  Future<void> load() async {
    isLoading = true;
    update();

    await _loadSummary();
    await _loadRatings();

    isLoading = false;
    update();
  }

  Future<void> _loadSummary() async {
    final result = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.ratingsSummary,
    );

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        if (data is Map && data['data'] is Map) {
          summary = RatingsSummaryModel.fromJson(
            Map<String, dynamic>.from(data['data'] as Map),
          );
        } else {
          summary = null;
        }
      },
    );
  }

  Future<void> _loadRatings() async {
    final result = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.ratings,
    );

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        if (data is Map && data['data'] is List) {
          ratings = (data['data'] as List)
              .map(
                (item) =>
                    RatingModel.fromJson(Map<String, dynamic>.from(item as Map)),
              )
              .toList();
        } else {
          ratings = [];
        }
      },
    );
  }
}
