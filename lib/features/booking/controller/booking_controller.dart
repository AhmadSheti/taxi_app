import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/car_type_model.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

/// كنترولر واحد يقود كامل تدفّق حجز الرحلة عبر الشاشات:
/// الوجهة → نوع السيارة → السائق → التأكيد → التتبّع → التقييم.
/// نسخة واحدة مشتركة (محقونة في AppBinding) تحتفظ بحالة التدفّق كلها.
class BookingController extends GetxController {

  // ─── نقطتا الرحلة (إحداثيات + عنوان) ───
  // قيم افتراضية في دمشق؛ المستخدم يعدّل العنوان النصّي.
  double pickupLat = 33.5138;
  double pickupLng = 36.2765;
  String pickupAddress = '';

  double destLat = 33.5301;
  double destLng = 36.2921;
  String destAddress = '';

  // ─── نوع السيارة + التقدير ───
  bool loadingCarTypes = false;
  List<CarTypeModel> carTypes = [];
  CarTypeModel? selectedCarType;
  Map<String, dynamic>? estimate; // نتيجة تقدير السعر

  // ─── السائقون ───
  bool loadingDrivers = false;
  List<DriverModel> drivers = [];
  DriverModel? selectedDriver;

  // ─── الخصم ───
  String? appliedDiscountCode;
  double? discountPercentage;
  bool validatingDiscount = false;

  // ─── الرحلة بعد الإنشاء + التتبّع ───
  bool submitting = false;
  RideModel? currentRide;
  Timer? _pollTimer;

  void _err(String msg) => Get.snackbar('خطأ', msg,
      backgroundColor: Colors.red.shade100, snackPosition: SnackPosition.BOTTOM);

  // ─── 1) أنواع السيارات ───
  Future<void> fetchCarTypes() async {
    loadingCarTypes = true;
    update();
    final res = await ApiService().makeRequest(method: ApiMethod.get, endPoint: EndPoints.carTypes);
    loadingCarTypes = false;
    res.fold(_err, (data) {
      final List list = data['data'] ?? [];
      carTypes = list.map((e) => CarTypeModel.fromJson(e)).toList();
      selectedCarType ??= carTypes.isNotEmpty ? carTypes.first : null;
    });
    update();
    if (selectedCarType != null) estimateFare();
  }

  void selectCarType(CarTypeModel type) {
    selectedCarType = type;
    estimate = null;
    update();
    estimateFare();
  }

  // ─── 2) تقدير السعر ───
  Future<void> estimateFare() async {
    if (selectedCarType == null) return;
    final res = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.estimate,
      body: {
        'car_type_id': selectedCarType!.id,
        'pickup_latitude': pickupLat,
        'pickup_longitude': pickupLng,
        'destination_latitude': destLat,
        'destination_longitude': destLng,
        if (appliedDiscountCode != null) 'discount_code': appliedDiscountCode,
      },
    );
    res.fold(_err, (data) => estimate = Map<String, dynamic>.from(data['data'] ?? {}));
    update();
  }

  // ─── 3) السائقون المتاحون ───
  Future<void> fetchDrivers() async {
    loadingDrivers = true;
    update();
    final res = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.availableDrivers,
      queryParams: {
        'latitude': pickupLat,
        'longitude': pickupLng,
        'radius_km': 50,
        if (selectedCarType != null) 'car_type_id': selectedCarType!.id,
      },
    );
    loadingDrivers = false;
    res.fold(_err, (data) {
      final List list = data['data'] ?? [];
      drivers = list.map((e) => DriverModel.fromJson(e)).toList();
    });
    update();
  }

  void selectDriver(DriverModel d) {
    selectedDriver = d;
    update();
  }

  // ─── 4) كود الخصم ───
  Future<void> validateDiscount(String code) async {
    if (code.trim().isEmpty || validatingDiscount) return;
    validatingDiscount = true;
    update();
    final res = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.validateDiscount,
      body: {'code': code.trim()},
    );
    validatingDiscount = false;
    res.fold(_err, (data) {
      appliedDiscountCode = data['data']?['code'];
      final rawPercentage = data['data']?['discount_percentage'];
      discountPercentage =
          rawPercentage == null ? null : double.tryParse(rawPercentage.toString());
      Get.snackbar('تم', 'طُبّق كود الخصم',
          backgroundColor: Colors.green.shade100, snackPosition: SnackPosition.BOTTOM);
      estimateFare();
    });
    update();
  }

  void removeDiscount() {
    appliedDiscountCode = null;
    discountPercentage = null;
    update();
    estimateFare();
  }

  // ─── 5) إنشاء الرحلة (بلا سائق — يُبَثّ لكل السائقين المتاحين) ───
  Future<int?> createRide() async {
    if (selectedCarType == null) {
      _err('اختر نوع السيارة أولاً');
      return null;
    }
    submitting = true;
    update();
    final res = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.rides,
      body: {
        'car_type_id': selectedCarType!.id,
        'pickup_latitude': pickupLat,
        'pickup_longitude': pickupLng,
        'pickup_address': pickupAddress.isEmpty ? 'نقطة الانطلاق' : pickupAddress,
        'destination_latitude': destLat,
        'destination_longitude': destLng,
        'destination_address': destAddress.isEmpty ? 'الوجهة' : destAddress,
        if (appliedDiscountCode != null) 'discount_code': appliedDiscountCode,
      },
    );
    submitting = false;
    int? rideId;
    res.fold(_err, (data) => rideId = data['data']?['id']);
    update();
    return rideId;
  }

  // ─── استئناف رحلة نشطة عند فتح/إعادة تشغيل التطبيق ───
  // يرجع معرّف الرحلة النشطة إن وُجدت، وإلا null.
  Future<int?> fetchActiveRide() async {
    final res = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.activeRide,
    );
    int? id;
    res.fold((_) {}, (data) {
      if (data['data'] != null) {
        currentRide = RideModel.fromJson(Map<String, dynamic>.from(data['data']));
        id = currentRide!.id;
      }
    });
    update();
    return id;
  }

  // ─── 6) التتبّع (استطلاع دوري) ───
  void startTracking(int rideId) {
    fetchRide(rideId);
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => fetchRide(rideId));
  }

  void stopTracking() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> fetchRide(int rideId) async {
    final res = await ApiService().makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.rideById(rideId),
    );
    res.fold((_) {}, (data) {
      if (data['data'] != null) {
        currentRide = RideModel.fromJson(Map<String, dynamic>.from(data['data']));
        if (currentRide!.isCompleted || currentRide!.isCancelled) stopTracking();
      }
    });
    update();
  }

  // ─── 7) إلغاء الرحلة ───
  Future<bool> cancelRide(int rideId, {String? reason}) async {
    final res = await ApiService().makeRequest(
      method: ApiMethod.put,
      endPoint: EndPoints.cancelRide(rideId),
      body: {if (reason != null) 'reason': reason},
    );
    bool ok = false;
    res.fold(_err, (_) {
      ok = true;
      stopTracking();
    });
    return ok;
  }

  // ─── 8) التقييم ───
  Future<bool> rate(int rideId, int score, String comment) async {
    final res = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.rateRide(rideId),
      body: {'score': score, if (comment.isNotEmpty) 'comment': comment},
    );
    bool ok = false;
    res.fold(_err, (_) => ok = true);
    return ok;
  }

  // إعادة ضبط التدفّق للبدء من جديد.
  void reset() {
    selectedCarType = null;
    estimate = null;
    drivers = [];
    selectedDriver = null;
    appliedDiscountCode = null;
    discountPercentage = null;
    currentRide = null;
    stopTracking();
    update();
  }

  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }
}
