import 'package:equatable/equatable.dart';

/// فئة الأخطاء الأساسية
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// خطأ من السيرفر
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// خطأ في الاتصال
class ConnectionFailure extends Failure {
  const ConnectionFailure({super.message = 'لا يوجد اتصال بالإنترنت'});
}

/// خطأ في التخزين المحلي
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'خطأ في التخزين المحلي'});
}

/// خطأ في المصادقة
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'خطأ في المصادقة'});
}

/// خطأ غير معروف
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'حدث خطأ غير متوقع'});
}
