import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../storage/app_storage.dart';
import '../../features/login/view/login_screen.dart';
import 'api_constants.dart';
import 'api_method.dart';

/// خدمة الاتصال بالسيرفر.
/// - صف عادي: ننشئ منه نسخة وقت الحاجة عبر ApiService().
/// - makeRequest: الدالة الوحيدة التي نستخدمها لأي طلب.
///   ترجع Either:
///     Left(String)  = رسالة خطأ
///     Right(dynamic) = بيانات النجاح (JSON)
class ApiService {
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status <= 500,
      ),
    );

    // Interceptor يضيف التوكن تلقائياً لكل طلب (لو المستخدم مسجّل دخول)،
    // ويطبع تفاصيل الطلب في الـ console للمساعدة في التصحيح.
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AppStorage.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
      PrettyDioLogger(requestBody: true, responseBody: true),
    ]);
  }

  late final Dio _dio;

  Future<Either<String, dynamic>> makeRequest({
    required ApiMethod method,
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response;
      switch (method) {
        case ApiMethod.get:
          response = await _dio.get(endPoint, queryParameters: queryParams);
          break;
        case ApiMethod.post:
          response = await _dio.post(endPoint, data: body, queryParameters: queryParams);
          break;
        case ApiMethod.put:
          response = await _dio.put(endPoint, data: body, queryParameters: queryParams);
          break;
        case ApiMethod.patch:
          response = await _dio.patch(endPoint, data: body, queryParameters: queryParams);
          break;
        case ApiMethod.delete:
          response = await _dio.delete(endPoint, data: body, queryParameters: queryParams);
          break;
      }

      final statusCode = response.statusCode ?? 0;
      // نجاح: أي كود بين 200 و 299
      if (statusCode >= 200 && statusCode < 300) {
        return Right(response.data);
      }
      // مصادقة فاشلة (توكن منتهٍ / غير صالح) → خروج تلقائي للدخول
      if (statusCode == 401 || statusCode == 403) {
        await _handleAuthError();
      }
      // خطأ: نحاول قراءة رسالة الخطأ من السيرفر
      return Left(_extractMessage(response.data, statusCode));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(_extractMessage(e.response!.data, e.response!.statusCode ?? 0));
      }
      return Left(e.message ?? 'حدث خطأ في الاتصال بالشبكة');
    } catch (e) {
      return Left(e.toString());
    }
  }

  // حارس يمنع تكرار التوجيه عند وصول عدة ردود 401/403 معاً.
  static bool _handlingAuth = false;

  /// عند فشل المصادقة: نمسح التوكن ونعيد المستخدم لشاشة الدخول مرة واحدة.
  Future<void> _handleAuthError() async {
    if (_handlingAuth || AppStorage.token == null) return;
    _handlingAuth = true;
    await AppStorage.clear();
    Get.offAll(() => const LoginScreen());
    Get.snackbar('انتهت الجلسة', 'يرجى تسجيل الدخول من جديد',
        snackPosition: SnackPosition.BOTTOM);
    _handlingAuth = false;
  }

  // يستخرج رسالة الخطأ من رد السيرفر، أو رسالة افتراضية حسب الكود.
  String _extractMessage(dynamic data, int statusCode) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    switch (statusCode) {
      case 401:
        return 'غير مصرّح لك، سجّل الدخول مجدداً';
      case 404:
        return 'العنصر غير موجود';
      case 500:
        return 'خطأ في السيرفر';
      default:
        return 'فشل الطلب';
    }
  }
}
