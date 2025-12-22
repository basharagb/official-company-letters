import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.jobTitle,
    required super.role,
    required super.status,
    required super.isSuperAdmin,
    required super.isCompanyOwner,
    super.companyId,
    super.companyName,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      jobTitle: json['job_title'] as String?,
      role: json['role'] as String? ?? 'user',
      status: json['status'] as String? ?? 'pending',
      isSuperAdmin:
          json['is_super_admin'] == 1 || json['is_super_admin'] == true,
      isCompanyOwner:
          json['is_company_owner'] == 1 || json['is_company_owner'] == true,
      companyId: json['company_id'] as int?,
      companyName: json['company'] != null
          ? (json['company'] is Map ? json['company']['name'] as String? : null)
          : null,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'job_title': jobTitle,
      'role': role,
      'status': status,
      'is_super_admin': isSuperAdmin ? 1 : 0,
      'is_company_owner': isCompanyOwner ? 1 : 0,
      'company_id': companyId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
