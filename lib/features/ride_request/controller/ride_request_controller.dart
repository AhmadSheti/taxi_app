import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/ride_details_model.dart';

class RideRequestController extends GetxController {
  bool isLoading = false;
  RideDetailsModel? currentRide;

  Future<void> acceptRide(int rideId) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: '$EndPoints.acceptRide/$rideId/accept',
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        Get.snackbar(
          'نجاح',
          'تم قبول الرحلة',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> rejectRide(int rideId, {String reason = 'بعيد جداً'}) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: '$EndPoints.rejectRide/$rideId/reject',
      body: {
        'reason': reason,
      },
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        Get.snackbar(
          'نجاح',
          'تم رفض الرحلة',
          backgroundColor: Colors.orange.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> markArrived(int rideId) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: '$EndPoints.arrivedRide/$rideId/arrived',
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        Get.snackbar(
          'نجاح',
          'تم تحديث الحالة إلى وصل',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> startRide(int rideId) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: '$EndPoints.startRide/$rideId/start',
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        Get.snackbar(
          'نجاح',
          'تم بدء الرحلة',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> sendTracking(int rideId, {required double latitude, required double longitude}) async {
    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: '$EndPoints.trackingRide/$rideId/tracking',
      body: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );

    result.fold(
      (error) {
        debugPrint('Tracking error: $error');
      },
      (_) {},
    );
  }

  Future<void> completeRide(int rideId, {required double distanceKm, required int durationMinutes}) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: '$EndPoints.completeRide/$rideId/complete',
      body: {
        'distance_km': distanceKm,
        'duration_minutes': durationMinutes,
      },
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        Get.snackbar(
          'نجاح',
          'تم إنهاء الرحلة',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> confirmPayment(int rideId) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: '$EndPoints.paymentConfirm/$rideId/payment/confirm',
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        Get.snackbar(
          'نجاح',
          'تم تأكيد استلام المبلغ',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> getRideDetails(int rideId) async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '$EndPoints.rideDetails/$rideId',
    );

    isLoading = false;
    update();

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
        if (data is Map<String, dynamic>) {
          currentRide = RideDetailsModel.fromJson(data);
        } else if (data is Map) {
          currentRide = RideDetailsModel.fromJson(Map<String, dynamic>.from(data));
        } else {
          currentRide = null;
        }
        update();
      },
    );
  }
}
