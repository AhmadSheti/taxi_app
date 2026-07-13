import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class DriverLocationModel {
  final double latitude;
  final double longitude;
  final String recordedAt;

  DriverLocationModel({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });

  factory DriverLocationModel.fromJson(Map<String, dynamic> json) {
    return DriverLocationModel(
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      recordedAt: json['recorded_at']?.toString() ?? '',
    );
  }
}

class TrackingPathPointModel {
  final double latitude;
  final double longitude;

  TrackingPathPointModel({required this.latitude, required this.longitude});

  factory TrackingPathPointModel.fromJson(Map<String, dynamic> json) {
    return TrackingPathPointModel(
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
    );
  }
}

class EnRouteController extends GetxController {
  EnRouteController({this.rideId = 501});

  final int rideId;
  bool isLoading = false;
  bool isSubmittingSos = false;
  DriverLocationModel? driverLocation;
  final List<TrackingPathPointModel> trackingPath = [];
  String driverName = 'السائق';
  String vehicleInfo = 'جارٍ التحضير';
  String etaText = 'جارٍ تحديث المسار';
  String rideStatus = 'pending';
  String rideStatusLabel = 'في انتظار الموافقة';

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTracking();
  }

  void startTracking() {
    refreshRideState();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => refreshRideState(),
    );
  }

  Future<void> refreshRideState() async {
    await fetchRideDetails();
    await fetchTracking();
  }

  Future<void> fetchRideDetails() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '${EndPoints.rideDetails}$rideId',
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        rideStatus = 'pending';
        rideStatusLabel = 'تعذر تحميل حالة الرحلة';
        update();
      },
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          rideStatus = responseData['status']?.toString() ?? 'pending';
          rideStatusLabel = _statusLabel(rideStatus);

          final driver = responseData['driver'];
          if (driver is Map) {
            driverName = driver['name']?.toString() ?? 'السائق';
          }

          vehicleInfo =
              responseData['vehicle_info']?.toString() ?? 'جارٍ التحضير';
          etaText = responseData['eta']?.toString() ?? 'جارٍ تحديث المسار';
        }
        update();
      },
    );
  }

  Future<void> fetchTracking() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '${EndPoints.rideTracking}$rideId/tracking',
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        etaText = 'تعذر تحديث المسار';
        update();
        Get.snackbar('خطأ', error, backgroundColor: Colors.red.shade100);
      },
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          if (responseData['driver_location'] is Map) {
            driverLocation = DriverLocationModel.fromJson(
              Map<String, dynamic>.from(responseData['driver_location']),
            );
          }

          driverName = responseData['driver_name']?.toString() ?? driverName;
          vehicleInfo = responseData['vehicle_info']?.toString() ?? vehicleInfo;
          etaText = responseData['eta']?.toString() ?? etaText;

          trackingPath.clear();
          final pathList = responseData['tracking_path'];
          if (pathList is List) {
            for (final item in pathList) {
              if (item is Map<String, dynamic>) {
                trackingPath.add(TrackingPathPointModel.fromJson(item));
              } else if (item is Map) {
                trackingPath.add(
                  TrackingPathPointModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                );
              }
            }
          }
        }
        update();
      },
    );
  }

  Future<void> sendSos() async {
    isSubmittingSos = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: '${EndPoints.rideSos}$rideId/sos',
      body: {},
    );

    isSubmittingSos = false;
    update();

    result.fold(
      (error) =>
          Get.snackbar('خطأ', error, backgroundColor: Colors.red.shade100),
      (data) {
        Get.snackbar(
          'نجاح',
          'تم إرسال طلب الطوارئ بنجاح',
          backgroundColor: Colors.red.shade100,
        );
      },
    );
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'تم قبول الرحلة';
      case 'in_progress':
      case 'active':
        return 'الرحلة جارية';
      case 'completed':
        return 'تمت الرحلة';
      case 'cancelled':
        return 'تم إلغاء الرحلة';
      default:
        return 'في انتظار الموافقة';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
