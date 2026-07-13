import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class TripCancelledController extends GetxController {
  TripCancelledController({required this.rideId});

  final int rideId;
  bool isSubmitting = false;
  bool hasError = false;
  String errorMessage = '';
  String successMessage = '';
  String? selectedReason;

  void selectReason(String? reason) {
    selectedReason = reason;
    update();
  }

  Future<void> cancelRide() async {
    if (isSubmitting) return;
    if (selectedReason == null || selectedReason!.isEmpty) {
      errorMessage = 'يرجى اختيار سبب الإلغاء.';
      hasError = true;
      update();
      return;
    }

    isSubmitting = true;
    hasError = false;
    errorMessage = '';
    successMessage = '';
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.put,
      endPoint: '${EndPoints.rideDetails}$rideId/cancel',
      body: {'reason': selectedReason},
    );

    isSubmitting = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        update();
      },
      (data) {
        hasError = false;
        successMessage = data['message']?.toString() ?? 'تم إلغاء الرحلة';
        update();
      },
    );
  }
}
