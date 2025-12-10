import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// تنفيذ مستودع المصادقة
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(email, password);
      // حفظ Token
      await _secureStorage.write(key: AppConfig.tokenKey, value: result.token);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _secureStorage.delete(key: AppConfig.tokenKey);
      return const Right(null);
    } catch (e) {
      // حتى لو فشل الـ API، نحذف Token محلياً
      await _secureStorage.delete(key: AppConfig.tokenKey);
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final result = await _remoteDataSource.getUser();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      // حفظ Token
      await _secureStorage.write(key: AppConfig.tokenKey, value: result.token);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? phone,
    String? jobTitle,
  }) async {
    try {
      final result = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        jobTitle: jobTitle,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// معالجة أخطاء Dio
  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionFailure(message: 'انتهت مهلة الاتصال');
      case DioExceptionType.connectionError:
        return const ConnectionFailure();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'حدث خطأ في السيرفر';
        if (statusCode == 401) {
          return AuthFailure(message: message);
        }
        return ServerFailure(message: message, statusCode: statusCode);
      default:
        return UnknownFailure(message: e.message ?? 'حدث خطأ غير متوقع');
    }
  }
}
