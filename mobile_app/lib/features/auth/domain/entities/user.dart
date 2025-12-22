import 'package:equatable/equatable.dart';

/// كيان المستخدم
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? jobTitle;
  final String? phone;
  final int? companyId;
  final String? companyName;
  final DateTime? createdAt;
  final bool isSuperAdmin;
  final bool isCompanyOwner;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.jobTitle,
    this.phone,
    this.companyId,
    this.companyName,
    this.createdAt,
    this.isSuperAdmin = false,
    this.isCompanyOwner = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        jobTitle,
        phone,
        companyId,
        companyName,
        createdAt,
        isSuperAdmin,
        isCompanyOwner,
      ];
}

/// استجابة تسجيل الدخول
class AuthResponse extends Equatable {
  final User user;
  final String token;

  const AuthResponse({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}
