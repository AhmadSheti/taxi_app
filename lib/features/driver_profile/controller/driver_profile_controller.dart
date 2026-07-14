import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/app_storage.dart';
import '../../login/view/login_screen.dart';

/// كنترولر تبويب «حسابي» — يجلب بيانات السائق من /driver/profile.
class DriverProfileController extends GetxController {
  bool isLoading = false;
  Map<String, dynamic>? data;

  Future<void> load() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.profile,
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (res) {
        final d = res['data'];
        data = d is Map ? Map<String, dynamic>.from(d) : null;
        update();
      },
    );
  }

  // اختصارات لقراءة البيانات بأمان
  String get name => data?['name']?.toString() ?? 'السائق';
  double get ratingAverage => (data?['rating_average'] ?? 0).toDouble();
  int get totalRides =>
      (data?['stats']?['total_rides'] ?? 0) is int
          ? data?['stats']?['total_rides'] ?? 0
          : int.tryParse('${data?['stats']?['total_rides']}') ?? 0;
  String get carLabel {
    final car = data?['car'];
    if (car is Map) {
      return '${car['brand'] ?? ''} ${car['model'] ?? ''}'.trim();
    }
    return 'لا توجد سيارة';
  }

  Future<void> logout() async {
    // نُبلغ السيرفر (حذف التوكن) ثم نمسح التخزين المحلي.
    await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.logout,
    );
    await AppStorage.clear();
    Get.offAll(() => const LoginScreen());
  }
}
