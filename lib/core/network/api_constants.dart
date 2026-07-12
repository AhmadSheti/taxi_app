// كل الروابط في مكان واحد. لو تغيّر عنوان السيرفر، نغيّره هنا فقط.
class ApiConstants {
  // عنوان السيرفر (Laravel) في الإنتاج.
  // للتطوير المحلي مع Android emulator: "http://10.0.2.2:8000/"
  // للجهاز الحقيقي على شبكة محلية: "http://<IP-جهازك>:8000/"
  static const String baseUrl = "https://mashwar.abukm.com/";
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
