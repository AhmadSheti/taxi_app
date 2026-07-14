import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/notification_model.dart';

/// كنترولر الإشعارات (بأسلوب GetBuilder).
/// المتغيّرات عادية (بدون .obs). عند تغيّرها نستدعي update()
/// فتُعيد كل `GetBuilder` بناء نفسها.
class NotificationsController extends GetxController {
  bool isLoading = false;
  List<NotificationModel> notifications = [];

  Future<void> fetchNotifications() async {
    isLoading = true;
    update(); // أخبر الواجهة أننا بدأنا التحميل

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.notifications,
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        Get.snackbar('خطأ', error,
            backgroundColor: Colors.red.shade100,
            snackPosition: SnackPosition.BOTTOM);
      },
      (data) {
        // شكل الرد: { "success": true, "data": [ {...}, {...} ] }
        final List list = data['data'] ?? [];
        notifications = list.map((e) => NotificationModel.fromJson(e)).toList();
        update(); // أعِد بناء القائمة
      },
    );
  }

  /// تُستدعى عند فتح الشاشة: نجلب الإشعارات للعرض، ثم نُعلّمها كلها
  /// كمقروءة على السيرفر تلقائياً (بلا زر، وبصمت دون إعادة جلب).
  Future<void> openNotifications() async {
    await fetchNotifications();
    await _markAllAsReadSilently();
  }

  Future<void> _markAllAsReadSilently() async {
    // لا نعرض رسالة نجاح/خطأ ولا نعيد الجلب — مجرد تحديث الحالة على السيرفر.
    await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.notificationsReadAll,
    );
  }
}
