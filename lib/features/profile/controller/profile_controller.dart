import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../../welcome/view/welcome_screen.dart';

/// كنترولر الملف الشخصي: يجلب بيانات العميل وإحصائياته، ويسجّل الخروج.
class ProfileController extends GetxController {
  bool isLoading = false;
  String name = '';
  String email = '';
  String phone = '';
  int totalRides = 0;
  int completedRides = 0;

  Future<void> fetchProfile() async {
    isLoading = true;
    update();
    final res = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.profile,
    );
    isLoading = false;
    res.fold((_) {}, (data) {
      final d = data['data'] ?? {};
      name = d['name'] ?? '';
      email = d['email'] ?? '';
      phone = d['phone'] ?? '';
      final stats = d['stats'] ?? {};
      totalRides = stats['total_rides'] ?? 0;
      completedRides = stats['completed_rides'] ?? 0;
    });
    update();
  }

  Future<void> logout() async {
    // نُخبر السيرفر (اختياري) ثم نحذف التوكن محلياً ونعود لشاشة الترحيب.
    await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.logout,
    );
    await AppStorage.clear();
    Get.offAll(() => const WelcomeScreen());
  }

  void confirmLogout() {
    Get.defaultDialog(
      title: 'تسجيل الخروج',
      middleText: 'هل تريد تسجيل الخروج؟',
      textConfirm: 'خروج',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        logout();
      },
    );
  }
}
