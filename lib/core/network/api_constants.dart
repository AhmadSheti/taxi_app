// كل الروابط في مكان واحد. لو تغيّر عنوان السيرفر، نغيّره هنا فقط.
class ApiConstants {
  // عنوان السيرفر (Laravel).
  // للتطوير المحلي مع Android emulator: "http://10.0.2.2:8000/"
  // للجهاز الحقيقي على شبكة محلية: "http://<IP-جهازك>:8000/"
  static const String baseUrl = "https://mashwar.abukm.com/";
}

// كل نقاط النهاية (Endpoints) الخاصة بتطبيق العميل.
class EndPoints {
  // ─── المصادقة ───
  static const String login = "api/customer/login";
  static const String register = "api/customer/register";
  static const String logout = "api/customer/logout";
  static const String me = "api/customer/me";

  // ─── الملف الشخصي ───
  static const String profile = "api/customer/profile";

  // ─── طلب الرحلة ───
  static const String carTypes = "api/customer/car-types";
  static const String estimate = "api/customer/rides/estimate";
  static const String availableDrivers = "api/customer/drivers/available";
  static const String validateDiscount = "api/customer/discount-codes/validate";

  // ─── الرحلات ───
  static const String rides = "api/customer/rides"; // POST لإنشاء / GET للسجلّ
  static const String activeRide = "api/customer/rides/active";

  // مسارات فيها معرّف الرحلة → دوال ثابتة (أنظف من التداخل النصّي)
  static String rideById(int id) => "api/customer/rides/$id";
  static String rideTracking(int id) => "api/customer/rides/$id/tracking";
  static String cancelRide(int id) => "api/customer/rides/$id/cancel";
  static String rateRide(int id) => "api/customer/rides/$id/rate";

  // ─── الحظر / البلاغات ───
  static const String blocks = "api/customer/blocks";
  static String unblock(int driverId) => "api/customer/blocks/$driverId";
  static const String reports = "api/customer/reports";

  // ─── الإشعارات ───
  static const String notifications = "api/customer/notifications";
  static const String notificationsReadAll = "api/customer/notifications/read-all";
}
