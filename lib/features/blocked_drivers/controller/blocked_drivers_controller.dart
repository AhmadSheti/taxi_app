import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class BlockedDriver {
  BlockedDriver({
    required this.driverId,
    required this.name,
    required this.reason,
    required this.blockedAt,
  });

  final int driverId;
  final String name;
  final String reason;
  final String blockedAt;

  factory BlockedDriver.fromJson(Map<String, dynamic> json) {
    return BlockedDriver(
      driverId: json['driver_id'] is int
          ? json['driver_id']
          : int.tryParse(json['driver_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      blockedAt: json['blocked_at']?.toString() ?? '',
    );
  }

  String get avatarLetter {
    return name.isNotEmpty ? name[0] : 'س';
  }
}

class BlockedDriversController extends GetxController {
  bool isLoading = false;
  bool isSubmitting = false;
  bool hasError = false;
  String errorMessage = '';
  List<BlockedDriver> blockedDrivers = [];

  @override
  void onInit() {
    super.onInit();
    fetchBlockedDrivers();
  }

  Future<void> fetchBlockedDrivers() async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.blockedDrivers,
    );

    isLoading = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        blockedDrivers = [];
        update();
      },
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is List) {
          blockedDrivers = responseData
              .whereType<Map<String, dynamic>>()
              .map(BlockedDriver.fromJson)
              .toList();
        } else {
          blockedDrivers = [];
        }
        update();
      },
    );
  }

  Future<void> unblockDriver(int driverId) async {
    if (isSubmitting) return;
    isSubmitting = true;
    errorMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.delete,
      endPoint: '${EndPoints.blockedDrivers}/$driverId',
    );

    isSubmitting = false;
    result.fold(
      (error) {
        errorMessage = error;
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: const Color(0x66EF5350),
          colorText: Colors.white,
        );
        update();
      },
      (data) {
        Get.snackbar(
          'نجاح',
          'تم إلغاء حظر السائق',
          backgroundColor: const Color(0x660F4C5C),
          colorText: Colors.white,
        );
        fetchBlockedDrivers();
      },
    );
  }

  Future<void> blockDriver(int driverId, String reason) async {
    if (isSubmitting) return;
    isSubmitting = true;
    errorMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.blockedDrivers,
      body: {'driver_id': driverId, 'reason': reason},
    );

    isSubmitting = false;
    result.fold(
      (error) {
        errorMessage = error;
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: const Color(0x66EF5350),
          colorText: Colors.white,
        );
        update();
      },
      (data) {
        Get.snackbar(
          'نجاح',
          'تم حظر السائق بنجاح',
          backgroundColor: const Color(0x660F4C5C),
          colorText: Colors.white,
        );
        fetchBlockedDrivers();
      },
    );
  }
}
