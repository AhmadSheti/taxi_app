import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../model/pending_ride_model.dart';
import 'availability_controller.dart';

/// كنترولر الطلبات المتاحة للسائق — مع استطلاع دوري (polling).
///
/// قواعد التشغيل (حسب المطلوب):
/// - يعمل الاستطلاع فقط عندما يكون السائق **نشطاً (online)** و**غير منشغل برحلة**.
/// - يتوقّف تلقائياً عند **قبول/بدء رحلة**، ويعود عند **إنهائها**.
/// - يتوقّف عند التحوّل إلى **غير متصل**، ويعود عند **الاتصال**.
/// (الـ backend أيضاً يمنع ظهور الطلبات للسائق غير النشط/المنشغل كطبقة أمان.)
class PendingRidesController extends GetxController {
  bool isLoading = false;
  bool onTrip = false; // هل السائق حالياً في رحلة نشطة؟
  List<PendingRideModel> pendingRides = [];

  Timer? _timer;
  static const Duration _interval = Duration(seconds: 8);

  // إشعار الواجهة بوصول طلب جديد (لعرض حوار القبول تلقائياً مرة واحدة لكل طلب).
  int? _lastNotifiedId;
  void Function(PendingRideModel ride)? onNewRequest;

  void _notifyIfNew() {
    if (pendingRides.isEmpty) {
      _lastNotifiedId = null;
      return;
    }
    final first = pendingRides.first;
    if (first.id != _lastNotifiedId) {
      _lastNotifiedId = first.id;
      onNewRequest?.call(first);
    }
  }

  // ─── التحكّم بالاستطلاع ───

  /// يبدأ الاستطلاع (يُستدعى عند الاتصال أو عند فتح لوحة التحكم وهو نشط).
  void startPolling() {
    if (onTrip) return; // لا نبحث أثناء رحلة نشطة
    _timer?.cancel();
    fetchPendingRides(showLoading: true); // أول جلب فوري مع مؤشّر
    _timer = Timer.periodic(_interval, (_) {
      if (!onTrip) fetchPendingRides();
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  /// عند الاتصال: ابدأ البحث.
  void goOnline() => startPolling();

  /// عند قطع الاتصال: أوقف البحث وفرّغ القائمة.
  void goOffline() {
    stopPolling();
    pendingRides = [];
    update();
  }

  /// عند قبول/بدء رحلة: أوقف البحث (السائق أصبح منشغلاً).
  void pauseForTrip() {
    onTrip = true;
    stopPolling();
    pendingRides = [];
    _lastNotifiedId = null;
    update();
  }

  /// عند إنهاء الرحلة: استأنف البحث إن كان السائق ما زال نشطاً.
  void resumeAfterTrip() {
    onTrip = false;
    final online = Get.isRegistered<AvailabilityController>()
        ? Get.find<AvailabilityController>().isOnline
        : true;
    if (online) startPolling();
  }

  // ─── الجلب ───

  Future<void> fetchPendingRides({bool showLoading = false}) async {
    if (showLoading) {
      isLoading = true;
      update();
    }

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.pendingRides,
    );

    isLoading = false;

    result.fold(
      (error) {
        update();
        // لا نُزعج المستخدم برسالة خطأ في كل نبضة استطلاع صامتة.
        if (showLoading) {
          Get.snackbar('خطأ', error,
              backgroundColor: Colors.red.shade100,
              snackPosition: SnackPosition.BOTTOM);
        }
      },
      (data) {
        final List list = data['data'] ?? [];
        pendingRides = list.map((e) => PendingRideModel.fromJson(e)).toList();
        _notifyIfNew(); // اعرض حوار القبول تلقائياً إن وصل طلب جديد
        update();
      },
    );
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }
}
