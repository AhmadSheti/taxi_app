import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class DriverArrivedController extends GetxController {
  DriverArrivedController({required this.rideId});

  final int rideId;
  bool isLoading = false;
  String driverName = 'السائق';
  String vehicleName = 'سيارة غير معروفة';
  String plateNumber = '----';
  String rating = '0.0';
  String statusLabel = 'في انتظار التحديث';

  @override
  void onInit() {
    super.onInit();
    fetchRideDetails();
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
        Get.snackbar('خطأ', error, backgroundColor: Colors.red.shade100);
        statusLabel = 'تعذر تحميل الرحلة';
        update();
      },
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          final rideStatus = responseData['status']?.toString() ?? '';
          statusLabel = _statusLabel(rideStatus);

          final driver = responseData['driver'];
          final car = responseData['car'];

          driverName = driver is Map<String, dynamic>
              ? driver['name']?.toString() ?? driverName
              : driverName;

          if (car is Map<String, dynamic>) {
            vehicleName =
                car['name']?.toString() ??
                car['model']?.toString() ??
                vehicleName;
            plateNumber =
                car['plate_number']?.toString() ??
                car['plate']?.toString() ??
                plateNumber;
            rating =
                car['rating']?.toString() ??
                car['rating_average']?.toString() ??
                rating;
          }

          if (plateNumber.isEmpty) {
            plateNumber =
                responseData['license_plate']?.toString() ?? plateNumber;
          }

          update();
        }
      },
    );
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'driver_arrived':
        return 'السائق وصل';
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
        return 'في انتظار تحديث الحالة';
    }
  }
}
