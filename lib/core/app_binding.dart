import 'package:get/get.dart';

import '../features/dashboard/controller/pending_rides_controller.dart';
import '../features/login/controller/login_controller.dart';
import '../features/notifications/controller/notifications_controller.dart';
import '../features/register/controller/register_controller.dart';

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
  }
}
