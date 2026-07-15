import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_service.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_constants.dart';

class ReportUserController extends GetxController {
  final descriptionController = TextEditingController();

  bool isLoading = false;

  /// سبب البلاغ المختار من الرقائق (اختياري).
  String? selectedReason;

  /// أسباب البلاغ الجاهزة التي تظهر كرقائق.
  final List<String> reasons = const [
    'سلوك غير لائق',
    'عدم دفع الأجرة',
    'تأخر عن الموعد',
    'إلغاء متكرر',
    'أخرى',
  ];

  void selectReason(String reason) {
    selectedReason = (selectedReason == reason) ? null : reason;
    update();
  }

  Future<void> submit({required int reportedId, int? rideId}) async {
    final text = descriptionController.text.trim();

    if (text.isEmpty && (selectedReason == null || selectedReason!.isEmpty)) {
      Get.snackbar(
        'خطأ',
        'الرجاء إدخال وصف للبلاغ',
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ندمج السبب المختار مع نص الوصف حتى يكون الوصف >= 10 أحرف.
    final description = [
      if (selectedReason != null && selectedReason!.isNotEmpty) selectedReason,
      if (text.isNotEmpty) text,
    ].join(' - ');

    final body = <String, dynamic>{
      'reported_id': reportedId,
      'description': description,
      if (rideId != null) 'ride_id': rideId,
    };

    isLoading = true;
    update();

    final result = await ApiService().makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.reports,
      body: body,
    );

    isLoading = false;
    update();

    result.fold(
      (error) {
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (data) {
        Get.snackbar(
          'تم',
          'تم إرسال البلاغ',
          backgroundColor: Colors.green.shade100,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      },
    );
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
