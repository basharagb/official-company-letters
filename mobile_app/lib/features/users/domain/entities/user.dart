import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? jobTitle;
  final String role;
  final String status;
  final bool isSuperAdmin;
  final bool isCompanyOwner;
  final int? companyId;
  final String? companyName;
  final String createdAt;
  final String? updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.jobTitle,
    required this.role,
    required this.status,
    required this.isSuperAdmin,
    required this.isCompanyOwner,
    this.companyId,
    this.companyName,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        jobTitle,
        role,
        status,
        isSuperAdmin,
        isCompanyOwner,
        companyId,
        companyName,
        createdAt,
        updatedAt,
      ];

  String get roleLabel {
    switch (role) {
      case 'admin':
        return 'أدمن';
      case 'manager':
        return 'مدير';
      default:
        return 'مستخدم';
    }
  }

  String get statusLabel {
    switch (status) {
      case 'approved':
        return 'معتمد';
      case 'pending':
        return 'قيد الانتظار';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }
}
