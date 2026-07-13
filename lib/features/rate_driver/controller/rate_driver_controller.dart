import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class RateDriverController extends GetxController {
  RateDriverController({required this.rideId});

  final int rideId;
  bool isSubmitting = false;
  String errorMessage = '';
  String successMessage = '';
  int selectedStars = 5;
  final List<String> selectedChips = [];
  final TextEditingController commentController = TextEditingController();

  void updateStars(int stars) {
    selectedStars = stars;
    update();
  }

  void toggleChip(String tag) {
    if (selectedChips.contains(tag)) {
      selectedChips.remove(tag);
    } else {
      selectedChips.add(tag);
    }
    update();
  }

  Future<void> submitRating() async {
    if (isSubmitting) return;

    isSubmitting = true;
    errorMessage = '';
    successMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: '${EndPoints.rideDetails}$rideId/rate',
      body: {'score': selectedStars, 'comment': commentController.text.trim()},
    );

    isSubmitting = false;
    result.fold(
      (error) {
        errorMessage = error;
        update();
      },
      (data) {
        successMessage = data['message']?.toString() ?? 'تم إرسال التقييم';
        update();
      },
    );
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
