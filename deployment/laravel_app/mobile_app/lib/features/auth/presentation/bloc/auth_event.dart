part of 'auth_bloc.dart';

/// أحداث المصادقة
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// التحقق من حالة المصادقة
class CheckAuthStatusEvent extends AuthEvent {}

/// تسجيل الدخول
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// تسجيل الخروج
class LogoutEvent extends AuthEvent {}
