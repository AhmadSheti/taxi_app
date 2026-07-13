import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class ActiveRideModel {
  final int id;
  final String status;
  final int estimatedFare;
  final String pickupAddress;
  final String destinationAddress;
  final String driverName;
  final double driverRating;

  ActiveRideModel({
    required this.id,
    required this.status,
    required this.estimatedFare,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.driverName,
    required this.driverRating,
  });

  factory ActiveRideModel.fromJson(Map<String, dynamic> json) {
    final driver = json['driver'] ?? {};
    return ActiveRideModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      estimatedFare:
          int.tryParse(json['estimated_fare']?.toString() ?? '') ?? 0,
      pickupAddress: json['pickup_address']?.toString() ?? '',
      destinationAddress: json['destination_address']?.toString() ?? '',
      driverName: driver['name']?.toString() ?? 'سائق',
      driverRating:
          double.tryParse(driver['rating_average']?.toString() ?? '') ?? 0.0,
    );
  }
}

class TripWaitingController extends GetxController {
  ActiveRideModel? activeRide;
  bool isLoading = false;
  bool isPolling = true;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchActiveRide();
    startPolling();
  }

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (isPolling) {
        fetchActiveRide();
      }
    });
  }

  Future<void> fetchActiveRide() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.activeRide,
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        activeRide = null;
        update();
      },
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic> && responseData.isNotEmpty) {
          activeRide = ActiveRideModel.fromJson(responseData);
        } else {
          activeRide = null;
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
