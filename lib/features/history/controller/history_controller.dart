import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/ride_model.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';
import '../../blocked_drivers/controller/blocked_drivers_controller.dart';

/// كنترولر سجلّ الرحلات: يجلب رحلات العميل (الكل / مكتملة / ملغاة).
class HistoryController extends GetxController {
  bool isLoading = false;
  List<RideModel> rides = [];
  String filter = 'all'; // all | completed | cancelled

  /// معرّف السائق الجاري حظره حالياً (لعرض مؤشّر التحميل على الزر).
  int? blockingDriverId;

  /// معرّفات السائقين الذين حُظِروا لتوّهم من هذه الشاشة (لتحديث حالة الزر).
  final Set<int> blockedDriverIds = {};

  Future<void> fetchRides() async {
    isLoading = true;
    update();
    final res = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.rides,
      queryParams: {'status': filter},
    );
    isLoading = false;
    res.fold(
      (_) {},
      (data) {
        final List list = data['data'] ?? [];
        rides = list.map((e) => RideModel.fromJson(e)).toList();
      },
    );
    update();
  }

  void setFilter(String f) {
    filter = f;
    update();
    fetchRides();
  }

  /// حظر سائق: يمنع مطابقة العميل مع هذا السائق في الرحلات القادمة.
  Future<void> blockDriver(int driverId, {String? reason}) async {
    if (blockingDriverId != null) return;
    blockingDriverId = driverId;
    update();

    final res = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.blocks,
      body: {
        'driver_id': driverId,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      },
    );

    blockingDriverId = null;
    res.fold(
      (error) => Get.snackbar('خطأ', error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM),
      (_) {
        blockedDriverIds.add(driverId);
        Get.snackbar('تم', 'تم حظر السائق ولن تتم مطابقتك معه مجدداً',
            backgroundColor: Colors.green.shade100,
            snackPosition: SnackPosition.BOTTOM);
        // مزامنة قائمة المحظورين إن كانت شاشتها مفتوحة.
        if (Get.isRegistered<BlockedDriversController>()) {
          Get.find<BlockedDriversController>().fetchBlocked();
        }
      },
    );
    update();
  }
}
