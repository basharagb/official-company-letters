import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// مصدر بيانات المصادقة عن بعد
abstract class AuthRemoteDataSource {
  /// تسجيل الدخول
  Future<AuthResponseModel> login(String email, String password);

  /// تسجيل الخروج
  Future<void> logout();

  /// جلب بيانات المستخدم الحالي
  Future<UserModel> getUser();

  /// تسجيل مستخدم جديد
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  /// تحديث الملف الشخصي
  Future<UserModel> updateProfile({
    required String name,
    String? phone,
    String? jobTitle,
  });

  /// تغيير كلمة المرور
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}

/// تنفيذ مصدر بيانات المصادقة
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل تسجيل الدخول',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {
      // تجاهل الأخطاء عند تسجيل الخروج
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.user);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب بيانات المستخدم',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل التسجيل',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? phone,
    String? jobTitle,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: {
          'name': name,
          if (phone != null) 'phone': phone,
          if (jobTitle != null) 'job_title': jobTitle,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل تحديث الملف الشخصي',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.changePassword,
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل تغيير كلمة المرور',
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
