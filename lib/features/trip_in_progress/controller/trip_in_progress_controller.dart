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

class TripInProgressController extends GetxController {
  TripInProgressController({required this.rideId});

  final int rideId;
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  String driverEta = 'جارٍ التحميل...';
  String fareText = 'جارٍ التحميل...';
  String fromAddress = '';
  String toAddress = '';
  String tripDuration = '';
  String statusLabel = 'الرحلة جارية';

  DriverLocationModel? driverLocation;
  final List<TrackingPathPointModel> trackingPath = [];

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    refreshTrip();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => refreshTrip());
  }

  Future<void> refreshTrip() async {
    await fetchRideDetails();
    await fetchTripTracking();
  }

  Future<void> fetchRideDetails() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '${EndPoints.rideDetails}$rideId',
    );

    isLoading = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        statusLabel = 'خطأ في تحميل البيانات';
        update();
      },
      (data) {
        hasError = false;
        errorMessage = '';
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          statusLabel = responseData['status']?.toString() ?? statusLabel;
          driverEta =
              responseData['eta']?.toString() ??
              responseData['time_remaining']?.toString() ??
              responseData['remaining_time']?.toString() ??
              responseData['duration']?.toString() ??
              driverEta;

          final fareValue =
              responseData['current_fare'] ??
              responseData['fare'] ??
              responseData['estimated_fare'] ??
              responseData['total_fare'];
          fareText = fareValue != null ? fareValue.toString() : fareText;

          fromAddress =
              responseData['pickup_address']?.toString() ??
              responseData['origin_address']?.toString() ??
              fromAddress;
          toAddress =
              responseData['destination_address']?.toString() ??
              responseData['destination_address']?.toString() ??
              toAddress;
          tripDuration =
              responseData['duration_text']?.toString() ??
              responseData['time_remaining']?.toString() ??
              responseData['eta']?.toString() ??
              tripDuration;
        }
        update();
      },
    );
  }

  Future<void> fetchTripTracking() async {
    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '${EndPoints.rideTracking}$rideId/tracking',
    );

    result.fold(
      (error) {
        // keep previous state, but show error if needed
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
