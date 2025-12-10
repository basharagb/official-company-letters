import '../../domain/entities/user.dart';

/// نموذج المستخدم للتحويل من/إلى JSON
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.jobTitle,
    super.phone,
    super.companyId,
    super.companyName,
    super.createdAt,
  });

  /// من JSON إلى Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      jobTitle: json['job_title'] as String?,
      phone: json['phone'] as String?,
      companyId: json['company_id'] as int?,
      companyName: json['company_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// من Model إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'job_title': jobTitle,
      'phone': phone,
      'company_id': companyId,
      'company_name': companyName,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// نموذج استجابة المصادقة
class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({required super.user, required super.token});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}
