import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user.dart';

/// واجهة مستودع المصادقة
abstract class AuthRepository {
  /// تسجيل الدخول
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  });

  /// تسجيل الخروج
  Future<Either<Failure, void>> logout();

  /// جلب بيانات المستخدم الحالي
  Future<Either<Failure, User>> getUser();

  /// تسجيل مستخدم جديد
  Future<Either<Failure, AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  /// تحديث الملف الشخصي
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? phone,
    String? jobTitle,
  });

  /// تغيير كلمة المرور
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}
