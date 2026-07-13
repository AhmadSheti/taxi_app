import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class SavedPlaceModel {
  final int? id;
  final String title;
  final String subtitle;
  final double? latitude;
  final double? longitude;
  final String? type;

  SavedPlaceModel({
    this.id,
    required this.title,
    required this.subtitle,
    this.latitude,
    this.longitude,
    this.type,
  });

  factory SavedPlaceModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'];

    return SavedPlaceModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      title:
          json['name']?.toString() ??
          json['title']?.toString() ??
          json['label']?.toString() ??
          'موقع محفوظ',
      subtitle:
          json['address']?.toString() ??
          json['subtitle']?.toString() ??
          json['description']?.toString() ??
          '',
      latitude: _parseDouble(
        json['latitude'] ?? json['lat'] ?? location?['latitude'],
      ),
      longitude: _parseDouble(
        json['longitude'] ?? json['lng'] ?? location?['longitude'],
      ),
      type: json['type']?.toString(),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class DestinationController extends GetxController {
  final List<SavedPlaceModel> savedPlaces = [];

  bool isLoading = false;
  SavedPlaceModel? selectedPlace;
  double? destinationLatitude;
  double? destinationLongitude;
  String? destinationLabel;

  Future<void> loadSavedPlaces() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.savedPlaces,
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
        savedPlaces.clear();

        final responseData = data['data'] ?? data;

        if (responseData is List) {
          for (final item in responseData) {
            if (item is Map<String, dynamic>) {
              savedPlaces.add(SavedPlaceModel.fromJson(item));
            } else if (item is Map) {
              savedPlaces.add(
                SavedPlaceModel.fromJson(Map<String, dynamic>.from(item)),
              );
            }
          }
        } else if (responseData is Map && responseData['data'] is List) {
          final list = responseData['data'] as List;
          for (final item in list) {
            if (item is Map<String, dynamic>) {
              savedPlaces.add(SavedPlaceModel.fromJson(item));
            } else if (item is Map) {
              savedPlaces.add(
                SavedPlaceModel.fromJson(Map<String, dynamic>.from(item)),
              );
            }
          }
        }

        update();
      },
    );
  }

  void selectPlace(SavedPlaceModel place) {
    selectedPlace = place;
    destinationLabel = place.title;
    destinationLatitude = place.latitude;
    destinationLongitude = place.longitude;
    update();
  }

  @override
  void onClose() {
    savedPlaces.clear();
    super.onClose();
  }
}
