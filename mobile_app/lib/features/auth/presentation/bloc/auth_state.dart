part of 'auth_bloc.dart';

/// حالات المصادقة
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class AuthInitial extends AuthState {}

/// جاري التحميل
class AuthLoading extends AuthState {}

/// مصادق (مسجل دخول)
class AuthAuthenticated extends AuthState {
  final User user;
  final bool needsOrganizationSetup;

  const AuthAuthenticated({
    required this.user,
    this.needsOrganizationSetup = false,
  });

  @override
  List<Object?> get props => [user, needsOrganizationSetup];
}

/// غير مصادق
class AuthUnauthenticated extends AuthState {}

/// خطأ
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
