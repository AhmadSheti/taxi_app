// كل الروابط في مكان واحد. لو تغيّر عنوان السيرفر، نغيّره هنا فقط.
class ApiConstants {
  // عنوان السيرفر (Laravel).
  // 10.0.2.2 = "localhost" بالنسبة لمحاكي أندرويد.
  // لو تشتغل على جهاز حقيقي ضع IP جهازك، مثل: http://192.168.1.10:8000/
  static const String baseUrl = "http://10.0.2.2:8000/";
}

// كل نقاط النهاية (Endpoints) الخاصة بتطبيق السائق.
class EndPoints {
  // المصادقة
  static const String login = "api/auth/login";
  static const String register = "api/auth/register";

  // الإشعارات (خاصة بالسائق / driver)
  static const String notifications = "api/driver/notifications";
  static const String notificationsReadAll = "api/driver/notifications/read-all";
}
