import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class CarTypeModel {
  final int id;
  final String typeName;
  final int baseFare;
  final int pricePerKm;
  final int? seats;

  CarTypeModel({
    required this.id,
    required this.typeName,
    required this.baseFare,
    required this.pricePerKm,
    this.seats,
  });

  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      typeName: json['type_name']?.toString() ?? 'غير معروف',
      baseFare: int.tryParse(json['base_fare']?.toString() ?? '') ?? 0,
      pricePerKm: int.tryParse(json['price_per_km']?.toString() ?? '') ?? 0,
      seats: int.tryParse(json['seats']?.toString() ?? ''),
    );
  }
}

class FareEstimateModel {
  final double distanceKm;
  final int durationMinutes;
  final int baseFare;
  final int distanceFare;
  final int subtotal;
  final int discountAmount;
  final int totalFare;

  FareEstimateModel({
    required this.distanceKm,
    required this.durationMinutes,
    required this.baseFare,
    required this.distanceFare,
    required this.subtotal,
    required this.discountAmount,
    required this.totalFare,
  });

  factory FareEstimateModel.fromJson(Map<String, dynamic> json) {
    return FareEstimateModel(
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '') ?? 0,
      durationMinutes:
          int.tryParse(json['duration_minutes']?.toString() ?? '') ?? 0,
      baseFare: int.tryParse(json['base_fare']?.toString() ?? '') ?? 0,
      distanceFare: int.tryParse(json['distance_fare']?.toString() ?? '') ?? 0,
      subtotal: int.tryParse(json['subtotal']?.toString() ?? '') ?? 0,
      discountAmount:
          int.tryParse(json['discount_amount']?.toString() ?? '') ?? 0,
      totalFare: int.tryParse(json['total_fare']?.toString() ?? '') ?? 0,
    );
  }
}

class CarTypeSelectionController extends GetxController {
  final List<CarTypeModel> carTypes = [];
  FareEstimateModel? fareEstimate;
  bool isLoading = false;
  bool isEstimating = false;
  int selectedCarTypeId = 0;

  Future<void> loadCarTypes() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.carTypes,
    );

    isLoading = false;
    update();

    result.fold(
      (error) => Get.snackbar(
        'خطأ',
        error,
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) {
        carTypes.clear();
        final responseData = data['data'] ?? data;

        if (responseData is List) {
          for (final item in responseData) {
            if (item is Map<String, dynamic>) {
              carTypes.add(CarTypeModel.fromJson(item));
            } else if (item is Map) {
              carTypes.add(
                CarTypeModel.fromJson(Map<String, dynamic>.from(item)),
              );
            }
          }
        }

        if (carTypes.isNotEmpty) {
          selectedCarTypeId = carTypes.first.id;
        }
        update();
      },
    );
  }

  Future<void> estimateFare({
    required double pickupLatitude,
    required double pickupLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    String discountCode = '',
  }) async {
    if (selectedCarTypeId == 0) {
      return;
    }

    isEstimating = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.estimateRide,
      body: {
        'car_type_id': selectedCarTypeId,
        'pickup_latitude': pickupLatitude,
        'pickup_longitude': pickupLongitude,
        'destination_latitude': destinationLatitude,
        'destination_longitude': destinationLongitude,
        'discount_code': discountCode,
      },
    );

    isEstimating = false;
    update();

    result.fold(
      (error) => Get.snackbar(
        'خطأ',
        error,
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          fareEstimate = FareEstimateModel.fromJson(responseData);
        }
        update();
      },
    );
  }

  void selectCarType(int id) {
    selectedCarTypeId = id;
    update();
  }
}
