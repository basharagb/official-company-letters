import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';

/// Interceptor للمصادقة - يضيف Token تلقائياً للـ Requests
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // جلب Token من التخزين الآمن
    final token = await _secureStorage.read(key: AppConfig.tokenKey);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // التعامل مع أخطاء المصادقة (401)
    if (err.response?.statusCode == 401) {
      // يمكن إضافة منطق تسجيل الخروج هنا
      // مثل: حذف Token وإعادة التوجيه لصفحة تسجيل الدخول
    }

    handler.next(err);
  }
}
