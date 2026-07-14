import 'package:get/get.dart';

import '../features/blocked_users/controller/blocked_users_controller.dart';
import '../features/car_details/controller/car_details_controller.dart';
import '../features/dashboard/controller/availability_controller.dart';
import '../features/dashboard/controller/pending_rides_controller.dart';
import '../features/driver_earning/controller/driver_earnings_controller.dart';
import '../features/driver_profile/controller/driver_profile_controller.dart';
import '../features/driver_ratings/controller/driver_ratings_controller.dart';
import '../features/login/controller/login_controller.dart';
import '../features/notifications/controller/notifications_controller.dart';
import '../features/register/controller/register_controller.dart';
import '../features/ride_request/controller/ride_request_controller.dart';
import '../features/trip_history/controller/trip_history_controller.dart';

/// مكان واحد لحقن كل الـ Controllers.
/// نربطه في main عبر GetMaterialApp(initialBinding: AppBinding()).
/// أي كنترولر جديد، أضِفه هنا فقط.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(NotificationsController());
    Get.put(RegisterController());
    Get.put(PendingRidesController());
    Get.put(DriverEarningsController());
    Get.put(AvailabilityController());
    Get.put(RideRequestController());
    Get.put(TripHistoryController());
    Get.put(DriverProfileController());
    Get.put(CarDetailsController());
    Get.put(DriverRatingsController());
    Get.put(BlockedUsersController());
  }
}
