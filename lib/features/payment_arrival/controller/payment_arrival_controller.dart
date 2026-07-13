import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_method.dart';
import '../../../core/network/api_service.dart';

class PaymentArrivalController extends GetxController {
  PaymentArrivalController({required this.rideId});

  final int rideId;
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  String status = 'اكتمل';
  String driverName = '';
  String driverCar = '';
  String plateNumber = '';
  String pickupAddress = '';
  String destinationAddress = '';
  String distanceKm = '';
  String durationMinutes = '';
  String baseFare = '';
  String estimatedFare = '';
  String finalFare = '';
  String discountAmount = '';
  String requestedAt = '';
  String completedAt = '';

  @override
  void onInit() {
    super.onInit();
    fetchRideDetails();
  }

  Future<void> fetchRideDetails() async {
    isLoading = true;
    update();

    final result = await ApiService.instance.makeRequest(
      method: ApiMethod.get,
      endPoint: '${EndPoints.rideDetails}$rideId',
    );

    isLoading = false;
    result.fold(
      (error) {
        hasError = true;
        errorMessage = error;
        update();
      },
      (data) {
        hasError = false;
        errorMessage = '';

        final responseData = data['data'] ?? data;
        if (responseData is Map<String, dynamic>) {
          status = responseData['status']?.toString() ?? status;
          pickupAddress = responseData['pickup_address']?.toString() ?? '';
          destinationAddress =
              responseData['destination_address']?.toString() ?? '';
          distanceKm = responseData['distance_km']?.toString() ?? '';
          durationMinutes = responseData['duration_minutes']?.toString() ?? '';
          baseFare = responseData['base_fare']?.toString() ?? '';
          estimatedFare = responseData['estimated_fare']?.toString() ?? '';
          finalFare = responseData['final_fare']?.toString() ?? '';
          discountAmount = responseData['discount_amount']?.toString() ?? '0';
          requestedAt = responseData['requested_at']?.toString() ?? '';
          completedAt = responseData['completed_at']?.toString() ?? '';

          final driver = responseData['driver'];
          if (driver is Map<String, dynamic>) {
            driverName = driver['name']?.toString() ?? '';
            final car = driver['car'];
            if (car is Map<String, dynamic>) {
              final model = car['model']?.toString() ?? '';
              final plate = car['plate_number']?.toString() ?? '';
              driverCar = model.isNotEmpty ? '$model' : '';
              plateNumber = plate;
            }
          }
        }
        update();
      },
    );
  }
}
