import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class UserReport {
  UserReport({
    required this.id,
    required this.status,
    required this.rideId,
    required this.reportedId,
    required this.description,
    required this.createdAt,
  });

  final int id;
  final String status;
  final int rideId;
  final int reportedId;
  final String description;
  final String createdAt;

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? '',
      rideId: json['ride_id'] is int
          ? json['ride_id']
          : int.tryParse(json['ride_id']?.toString() ?? '') ?? 0,
      reportedId: json['reported_id'] is int
          ? json['reported_id']
          : int.tryParse(json['reported_id']?.toString() ?? '') ?? 0,
      description: json['description']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class ReportIssueController extends GetxController {
  bool isLoading = false;
  bool isSubmitting = false;
  bool hasError = false;
  String errorMessage = '';
  String successMessage = '';
  List<UserReport> reports = [];

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: EndPoints.reports,
    );

    isLoading = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        reports = [];
        update();
      },
      (data) {
        final responseData = data['data'] ?? data;
        if (responseData is List) {
          reports = responseData
              .whereType<Map<String, dynamic>>()
              .map(UserReport.fromJson)
              .toList();
        } else {
          reports = [];
        }
        update();
      },
    );
  }

  Future<void> submitReport({
    required int rideId,
    required int reportedId,
    required String description,
  }) async {
    if (isSubmitting) return;
    isSubmitting = true;
    hasError = false;
    errorMessage = '';
    successMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.post,
      endPoint: EndPoints.reports,
      body: {
        'ride_id': rideId,
        'reported_id': reportedId,
        'description': description,
      },
    );

    isSubmitting = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        Get.snackbar(
          'خطأ',
          error,
          backgroundColor: const Color(0x66EF5350),
          colorText: Colors.white,
        );
        update();
      },
      (data) {
        successMessage = data['message']?.toString() ?? 'تم إرسال البلاغ بنجاح';
        Get.snackbar(
          'نجاح',
          successMessage,
          backgroundColor: const Color(0x660F4C5C),
          colorText: Colors.white,
        );
        fetchReports();
      },
    );
  }
}
