import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class DriverModel {
  final int id;
  final String name;
  final String availability;
  final double ratingAverage;
  final int ratingCount;
  final double distanceKm;
  final String plateNumber;
  final String model;
  final String color;
  final int? carTypeId;
  final String? carTypeName;
  final int? baseFare;
  final int? pricePerKm;
  final double? latitude;
  final double? longitude;

  DriverModel({
    required this.id,
    required this.name,
    required this.availability,
    required this.ratingAverage,
    required this.ratingCount,
    required this.distanceKm,
    required this.plateNumber,
    required this.model,
    required this.color,
    this.carTypeId,
    this.carTypeName,
    this.baseFare,
    this.pricePerKm,
    this.latitude,
    this.longitude,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    final car = json['car'] ?? {};
    final carType = car['car_type'] ?? {};
    final location = json['location'] ?? {};

    return DriverModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? 'سائق',
      availability: json['availability']?.toString() ?? 'offline',
      ratingAverage:
          double.tryParse(json['rating_average']?.toString() ?? '') ?? 0.0,
      ratingCount: int.tryParse(json['rating_count']?.toString() ?? '') ?? 0,
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '') ?? 0.0,
      plateNumber: car['plate_number']?.toString() ?? '',
      model: car['model']?.toString() ?? '',
      color: car['color']?.toString() ?? '',
      carTypeId: int.tryParse(carType['id']?.toString() ?? ''),
      carTypeName: carType['type_name']?.toString(),
      baseFare: int.tryParse(carType['base_fare']?.toString() ?? ''),
      pricePerKm: int.tryParse(carType['price_per_km']?.toString() ?? ''),
      latitude: double.tryParse(location['latitude']?.toString() ?? ''),
      longitude: double.tryParse(location['longitude']?.toString() ?? ''),
    );
  }
}

class DriverSelectionController extends GetxController {
  final List<DriverModel> drivers = [];
  bool isLoading = false;
  int selectedFilterIndex = 0;

  Future<void> loadAvailableDrivers() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.availableDrivers,
      queryParams: {
        'latitude': '33.5138',
        'longitude': '36.2765',
        'radius_km': '5',
      },
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
        drivers.clear();
        final responseData = data['data'] ?? data;

        if (responseData is List) {
          for (final item in responseData) {
            if (item is Map<String, dynamic>) {
              drivers.add(DriverModel.fromJson(item));
            } else if (item is Map) {
              drivers.add(
                DriverModel.fromJson(Map<String, dynamic>.from(item)),
              );
            }
          }
        }

        sortDrivers();
        update();
      },
    );
  }

  void changeFilter(int index) {
    selectedFilterIndex = index;
    sortDrivers();
    update();
  }

  void sortDrivers() {
    if (drivers.isEmpty) return;

    switch (selectedFilterIndex) {
      case 0:
        drivers.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case 1:
        drivers.sort((a, b) => b.ratingAverage.compareTo(a.ratingAverage));
        break;
      case 2:
        drivers.sort((a, b) => b.ratingCount.compareTo(a.ratingCount));
        break;
      case 3:
        drivers.sort(
          (a, b) => (a.baseFare ?? 999999).compareTo(b.baseFare ?? 999999),
        );
        break;
    }
  }
}
