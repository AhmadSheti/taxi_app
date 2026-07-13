// كل الروابط في مكان واحد. لو تغيّر عنوان السيرفر، نغيّره هنا فقط.
class ApiConstants {
  // عنوان السيرفر (Laravel) في الإنتاج.
  // للتطوير المحلي مع Android emulator: "http://10.0.2.2:8000/"
  // للجهاز الحقيقي على شبكة محلية: "http://<IP-جهازك>:8000/"
  static const String baseUrl = "https://mashwar.abukm.com/";
}

// كل نقاط النهاية (Endpoints) الخاصة بتطبيق العميل.
class EndPoints {
  // المصادقة
  static const String login = "api/auth/login";
  static const String register = "api/auth/register";
  static const String verifyOtp = "api/auth/verify-otp";
  static const String forgotPassword = "api/auth/forgot-password";
  static const String savedPlaces = "api/customer/saved-places";
  static const String carTypes = "api/customer/car-types";
  static const String estimateRide = "api/customer/rides/estimate";
  static const String availableDrivers = "api/customer/drivers/available";
  static const String validateDiscountCode =
      "api/customer/discount-codes/validate";
  static const String createRide = "api/customer/rides";
  static const String activeRide = "api/customer/rides/active";
  static const String profile = "api/customer/profile";
  static const String blockedDrivers = "api/customer/blocks";
  static const String reports = "api/customer/reports";
  static const String rideTracking = "api/customer/rides/";
  static const String rideDetails = "api/customer/rides/";
  static const String rideSos = "api/customer/rides/";

  // الإشعارات (خاصة بالعميل / customer)
  static const String notifications = "api/customer/notifications";
  static const String notificationsReadAll =
      "api/customer/notifications/read-all";
}
