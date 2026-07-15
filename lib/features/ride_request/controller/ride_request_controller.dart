import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../dashboard/controller/pending_rides_controller.dart';
import '../model/ride_details_model.dart';

class RideRequestController extends GetxController {
  bool isLoading = false;
  RideDetailsModel? currentRide;

  // معرّف الرحلة الحالية — يُضبط عند قبول الطلب ويبقى ثابتاً طوال الرحلة،
  // حتى لو لم تُحمّل تفاصيل الرحلة بعد.
  int _currentRideId = 0;
  int get currentRideId => currentRide?.id ?? _currentRideId;

  /// إنهاء الرحلة: نمسح الحالة ونستأنف استطلاع الطلبات المتاحة.
  void finishTrip() {
    currentRide = null;
    _currentRideId = 0;
    if (Get.isRegistered<PendingRidesController>()) {
      Get.find<PendingRidesController>().resumeAfterTrip();
    }
    update();
  }

  /// استئناف الرحلة النشطة عند فتح/إعادة تشغيل التطبيق.
  /// يرجع الرحلة النشطة إن وُجدت (accepted / driver_arrived / in_progress) وإلا null.
  Future<RideDetailsModel?> fetchActiveRide() async {
    final result = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.activeRide,
    );

    RideDetailsModel? ride;
    result.fold((_) {}, (data) {
      final d = (data is Map) ? data['data'] : null;
      if (d is Map) {
        ride = RideDetailsModel.fromJson(Map<String, dynamic>.from(d));
        currentRide = ride;
      }
    });
    update();
    return ride;
  }

  Future<void> acceptRide(int rideId) async {
    isLoading = true;
    update();

    final result = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.acceptRide(rideId),
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
        // نثبّت معرّف الرحلة المقبولة، ونحمّل تفاصيلها للعرض إن توفّرت.
        _currentRideId = rideId;
        final d = (data is Map) ? data['data'] : null;
        if (d is Map) {
          currentRide = RideDetailsModel.fromJson(Map<String, dynamic>.from(d));
        }
        // بدأت رحلة → أوقف استطلاع الطلبات المتاحة.
        Get.find<PendingRidesController>().pauseForTrip();
        update();
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

    final result = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.rejectRide(rideId),
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

    final result = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.arrivedRide(rideId),
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

    final result = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.startRide(rideId),
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
    final result = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.trackingRide(rideId),
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

    final result = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.completeRide(rideId),
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
        // انتهت الرحلة → استأنف استطلاع الطلبات إن كان السائق نشطاً.
        Get.find<PendingRidesController>().resumeAfterTrip();
        Get.snackbar(
          'نجاح',
          'تم إنهاء الرحلة',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// إلغاء الرحلة من طرف السائق (مثلاً: العميل لم يحضر).
  Future<bool> cancelRide(int rideId, {String reason = 'العميل لم يحضر'}) async {
    isLoading = true;
    update();

    final result = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.cancelRide(rideId),
      body: {'reason': reason},
    );

    isLoading = false;
    update();

    bool ok = false;
    result.fold(
      (error) {
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100, snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        ok = true;
        // انتهت الرحلة → استأنف استطلاع الطلبات إن كان السائق نشطاً.
        Get.find<PendingRidesController>().resumeAfterTrip();
        Get.snackbar('تم', 'تم إلغاء الرحلة',
            backgroundColor: Colors.orange.shade100, snackPosition: SnackPosition.BOTTOM);
      },
    );
    return ok;
  }

  Future<void> confirmPayment(int rideId) async {
    isLoading = true;
    update();

    final result = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.paymentConfirm(rideId),
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

    final result = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.rideById(rideId),
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
      (response) {
        // شكل الرد: { success, data: { ...الرحلة... } } — نأخذ المستوى الداخلي.
        final map = (response is Map) ? response['data'] : null;
        if (map is Map) {
          currentRide = RideDetailsModel.fromJson(Map<String, dynamic>.from(map));
        } else {
          currentRide = null;
        }
        update();
      },
    );
  }
}
