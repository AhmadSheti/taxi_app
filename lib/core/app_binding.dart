import 'package:get/get.dart';

import '../features/booking/controller/booking_controller.dart';
import '../features/home/controller/home_controller.dart';
import '../features/login/controller/login_controller.dart';
import '../features/notifications/controller/notifications_controller.dart';

/// حقن الـ Controllers المشتركة (المستخدمة عبر أكثر من شاشة) مرة واحدة.
/// الشاشات الثانوية (السجلّ، الملف، المحظورون...) تُنشئ كنترولرها محلياً
/// عبر GetBuilder(init:) فلا حاجة لتسجيلها هنا.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    Get.put(BookingController(), permanent: true);
  }
}
