import '../../domain/entities/user_activity.dart';

class UserActivityModel extends UserActivity {
  const UserActivityModel({
    required super.id,
    required super.type,
    required super.action,
    required super.description,
    super.referenceNumber,
    super.company,
    required super.createdAt,
    super.dateHijri,
  });

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    return UserActivityModel(
      id: json['id'] as int,
      type: json['type'] as String,
      action: json['action'] as String,
      description: json['description'] as String,
      referenceNumber: json['reference_number'] as String?,
      company: json['company'] as String?,
      createdAt: json['created_at'] as String,
      dateHijri: json['date_hijri'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'action': action,
      'description': description,
      'reference_number': referenceNumber,
      'company': company,
      'created_at': createdAt,
      'date_hijri': dateHijri,
    };
  }
}
