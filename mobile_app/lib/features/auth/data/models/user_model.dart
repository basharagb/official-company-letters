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
    super.isSuperAdmin = false,
    super.isCompanyOwner = false,
  });

  /// من JSON إلى Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // استخراج اسم الشركة من كائن company إذا كان موجوداً
    String? companyName;
    if (json['company'] != null && json['company'] is Map) {
      companyName = json['company']['name'] as String?;
    } else {
      companyName = json['company_name'] as String?;
    }

    return UserModel(
      id: _parseInt(json['id']),
      name: json['name'] as String,
      email: json['email'] as String,
      jobTitle: json['job_title'] as String?,
      phone: json['phone'] as String?,
      companyId: _parseIntNullable(json['company_id']),
      companyName: companyName,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      isSuperAdmin:
          json['is_super_admin'] == 1 || json['is_super_admin'] == true,
      isCompanyOwner:
          json['is_company_owner'] == 1 || json['is_company_owner'] == true,
    );
  }

  /// تحويل القيمة إلى int (يدعم String و int)
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  /// تحويل القيمة إلى int? (يدعم String و int و null)
  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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
      'is_super_admin': isSuperAdmin,
      'is_company_owner': isCompanyOwner,
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
