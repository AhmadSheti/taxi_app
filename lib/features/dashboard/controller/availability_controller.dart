import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import 'pending_rides_controller.dart';

class AvailabilityController extends GetxController {
  bool isLoading = false;
  bool isOnline = true;

  /// يجلب الحالة الحقيقية للسائق من السيرفر (online/offline/busy).
  Future<void> syncStatus() async {
    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.me,
    );
    result.fold((_) {}, (data) {
      final av = data['data']?['availability'];
      // نعتبره متصلاً فقط إذا كانت الحالة online (busy تعني منشغلاً برحلة).
      isOnline = av == 'online';
      update();
    });
  }

  Future<void> toggleAvailability() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.availability,
      body: {
        'availability': isOnline ? 'offline' : 'online',
      },
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (_) {
        isOnline = !isOnline;
        update();

        // ربط الحالة بالاستطلاع: عند الاتصال نبدأ البحث، وعند قطعه نوقفه.
        final pending = Get.find<PendingRidesController>();
        if (isOnline) {
          pending.goOnline();
        } else {
          pending.goOffline();
        }
      },
    );
  }
}
