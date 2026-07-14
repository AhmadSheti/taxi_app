// كل الروابط في مكان واحد. لو تغيّر عنوان السيرفر، نغيّره هنا فقط.
class ApiConstants {
  // عنوان السيرفر (Laravel).
  // للتطوير المحلي مع Android emulator: "http://10.0.2.2:8000/"
  // للجهاز الحقيقي على شبكة محلية: "http://<IP-جهازك>:8000/"
  static const String baseUrl = "https://mashwar.abukm.com/";
}

// كل نقاط النهاية (Endpoints) الخاصة بتطبيق السائق.
class EndPoints {
  // ─── المصادقة ───
  static const String login = "api/driver/login";
  static const String register = "api/driver/register";
  static const String verifyOtp = "api/driver/verify-otp";
  static const String resendOtp = "api/driver/resend-otp";
  static const String logout = "api/driver/logout";
  static const String me = "api/driver/me";

  // ─── الملف الشخصي / السيارة / الحالة / الموقع ───
  static const String profile = "api/driver/profile";
  static const String car = "api/driver/car";
  static const String carTypes = "api/driver/car-types";
  static const String availability = "api/driver/availability";
  static const String location = "api/driver/location";

  // ─── الرحلات (Driver) ───
  static const String pendingRides = "api/driver/rides/pending";
  static const String activeRide = "api/driver/rides/active";
  static const String tripHistory = "api/driver/rides";

  // مسارات فيها معرّف الرحلة → نبنيها بدوال ثابتة (أنظف من التداخل النصّي)
  static String rideById(int id) => "api/driver/rides/$id";
  static String acceptRide(int id) => "api/driver/rides/$id/accept";
  static String rejectRide(int id) => "api/driver/rides/$id/reject";
  static String arrivedRide(int id) => "api/driver/rides/$id/arrived";
  static String startRide(int id) => "api/driver/rides/$id/start";
  static String completeRide(int id) => "api/driver/rides/$id/complete";
  static String cancelRide(int id) => "api/driver/rides/$id/cancel";
  static String trackingRide(int id) => "api/driver/rides/$id/tracking";
  static String paymentConfirm(int id) => "api/driver/rides/$id/payment/confirm";

  // ─── الأرباح ───
  static const String earningsSummary = "api/driver/earnings/summary";
  static const String earningsChart = "api/driver/earnings/chart";
  static const String earningsCommission = "api/driver/earnings/commission";

  // ─── التقييمات ───
  static const String ratings = "api/driver/ratings";
  static const String ratingsSummary = "api/driver/ratings/summary";

  // ─── الحظر / البلاغات ───
  static const String blocks = "api/driver/blocks";
  static const String reports = "api/driver/reports";

  // ─── الإشعارات ───
  static const String notifications = "api/driver/notifications";
  static const String notificationsReadAll = "api/driver/notifications/read-all";
  static const String notificationsFcmToken = "api/driver/notifications/fcm-token";
}
