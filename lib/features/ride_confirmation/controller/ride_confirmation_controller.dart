import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class DiscountValidationModel {
  final String code;
  final int discountPercentage;
  final String expiryDate;

  DiscountValidationModel({
    required this.code,
    required this.discountPercentage,
    required this.expiryDate,
  });

  factory DiscountValidationModel.fromJson(Map<String, dynamic> json) {
    return DiscountValidationModel(
      code: json['code']?.toString() ?? '',
      discountPercentage:
          int.tryParse(json['discount_percentage']?.toString() ?? '') ?? 0,
      expiryDate: json['expiry_date']?.toString() ?? '',
    );
  }
}

class RideCreateModel {
  final int id;
  final String status;
  final int estimatedFare;
  final String requestedAt;
  final String? driverName;

  RideCreateModel({
    required this.id,
    required this.status,
    required this.estimatedFare,
    required this.requestedAt,
    this.driverName,
  });

  factory RideCreateModel.fromJson(Map<String, dynamic> json) {
    final driver = json['driver'] ?? {};
    return RideCreateModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      estimatedFare:
          int.tryParse(json['estimated_fare']?.toString() ?? '') ?? 0,
      requestedAt: json['requested_at']?.toString() ?? '',
      driverName: driver['name']?.toString(),
    );
  }
}

class RideConfirmationController extends GetxController {
  final TextEditingController discountCodeController = TextEditingController(
    text: 'MISHWAR10',
  );

  bool isValidatingDiscount = false;
  bool isCreatingRide = false;

  DiscountValidationModel? discount;
  RideCreateModel? ride;

  Future<void> validateDiscount() async {
    final code = discountCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar(
        'تحذير',
        'أدخل كود الخصم',
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    isValidatingDiscount = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.validateDiscountCode,
      body: {'code': code},
    );

    isValidatingDiscount = false;
    update();

    result.fold(
      (error) =>
          Get.snackbar('خطأ', error, backgroundColor: Colors.red.shade100),
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          discount = DiscountValidationModel.fromJson(responseData);
        }
        update();
      },
    );
  }

  Future<void> createRide() async {
    isCreatingRide = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.createRide,
      body: {
        'driver_id': 12,
        'car_type_id': 2,
        'pickup_latitude': 33.5138,
        'pickup_longitude': 36.2765,
        'pickup_address': 'Baghdad St, opposite Al-Sham Pharmacy',
        'destination_latitude': 33.5301,
        'destination_longitude': 36.2921,
        'destination_address': 'Al-Mazzeh, in front of Al-Zahraa Hospital',
        'discount_code': discountCodeController.text.trim(),
      },
    );

    isCreatingRide = false;
    update();

    result.fold(
      (error) =>
          Get.snackbar('خطأ', error, backgroundColor: Colors.red.shade100),
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          ride = RideCreateModel.fromJson(responseData);
        }
        update();
      },
    );
  }

  @override
  void onClose() {
    discountCodeController.dispose();
    super.onClose();
  }
}
