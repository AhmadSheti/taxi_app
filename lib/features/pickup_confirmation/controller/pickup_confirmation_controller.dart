import 'package:get/get.dart';

class PickupConfirmationController extends GetxController {
  PickupConfirmationController({
    required this.initialAddress,
    required this.initialLatitude,
    required this.initialLongitude,
  }) {
    pickupAddress = initialAddress;
    pickupLatitude = initialLatitude;
    pickupLongitude = initialLongitude;
  }

  final String initialAddress;
  final double initialLatitude;
  final double initialLongitude;

  late String pickupAddress;
  late double pickupLatitude;
  late double pickupLongitude;

  void updatePickupLocation({
    String? address,
    double? latitude,
    double? longitude,
  }) {
    pickupAddress = address ?? pickupAddress;
    pickupLatitude = latitude ?? pickupLatitude;
    pickupLongitude = longitude ?? pickupLongitude;
    update();
  }
}
