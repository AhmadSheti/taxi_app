import 'package:get_storage/get_storage.dart';

/// تخزين محلي بسيط جداً. حالياً نستخدمه لحفظ توكن الدخول.
/// (GetStorage يشبه SharedPreferences لكن أبسط بكثير)
class AppStorage {
  static final GetStorage _box = GetStorage();

  static const String _tokenKey = 'token';

  // حفظ التوكن بعد نجاح تسجيل الدخول
  static Future<void> saveToken(String token) => _box.write(_tokenKey, token);

  // قراءة التوكن (يرجع null إذا لم يسجّل المستخدم دخوله)
  static String? get token => _box.read(_tokenKey);

  // هل المستخدم مسجّل دخول؟
  static bool get isLoggedIn => token != null;

  // حذف التوكن عند تسجيل الخروج
  static Future<void> clear() => _box.remove(_tokenKey);
}
