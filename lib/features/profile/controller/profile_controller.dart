import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class ProfileController extends GetxController {
  bool isLoading = false;
  bool isSubmitting = false;
  bool hasError = false;
  String errorMessage = '';
  String successMessage = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();

  String memberSince = '';
  String ridesCount = '0';
  String ratingAverage = '0.0';
  String favoritesCount = '0';

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.profile,
    );

    isLoading = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        update();
      },
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          nameController.text = responseData['name']?.toString() ?? '';
          emailController.text = responseData['email']?.toString() ?? '';
          phoneController.text = responseData['phone']?.toString() ?? '';
          memberSince = responseData['member_since']?.toString() ?? '';

          final stats = responseData['stats'];
          if (stats is Map<String, dynamic>) {
            ridesCount = stats['rides_count']?.toString() ?? ridesCount;
            ratingAverage =
                stats['rating_average']?.toString() ?? ratingAverage;
            favoritesCount =
                stats['favorites_count']?.toString() ?? favoritesCount;
          }
        }
        update();
      },
    );
  }

  Future<void> updateProfile() async {
    if (isSubmitting) return;
    isSubmitting = true;
    hasError = false;
    errorMessage = '';
    successMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.profile,
      body: {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'avatar': avatarController.text.trim(),
      },
    );

    isSubmitting = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        update();
      },
      (data) {
        successMessage = data['message']?.toString() ?? 'تم تحديث الملف الشخصي';
        update();
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    avatarController.dispose();
    super.onClose();
  }
}
