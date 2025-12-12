import '../../domain/entities/dashboard_stats.dart';

/// نموذج إحصائيات لوحة التحكم
class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.userName,
    super.companyName,
    required super.totalLetters,
    required super.draftLetters,
    required super.issuedLetters,
    required super.sentLetters,
    required super.totalTemplates,
    required super.totalRecipients,
    required super.totalOrganizations,
    required super.recentLetters,
    super.subscription,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      userName: json['user_name'] ?? json['user']?['name'] ?? 'مستخدم',
      companyName: json['company_name'] ?? json['company']?['name'],
      totalLetters: json['total_letters'] ?? 0,
      draftLetters: json['draft_letters'] ?? 0,
      issuedLetters: json['issued_letters'] ?? 0,
      sentLetters: json['sent_letters'] ?? 0,
      totalTemplates: json['total_templates'] ?? 0,
      totalRecipients: json['total_recipients'] ?? 0,
      totalOrganizations: json['total_organizations'] ?? 0,
      recentLetters: (json['recent_letters'] as List<dynamic>?)
              ?.map((e) => RecentLetterModel.fromJson(e))
              .toList() ??
          [],
      subscription: json['subscription'] != null
          ? SubscriptionInfoModel.fromJson(json['subscription'])
          : null,
    );
  }
}

/// نموذج الخطاب الحديث
class RecentLetterModel extends RecentLetter {
  const RecentLetterModel({
    required super.id,
    super.referenceNumber,
    required super.subject,
    required super.status,
    super.recipientName,
    required super.createdAt,
  });

  factory RecentLetterModel.fromJson(Map<String, dynamic> json) {
    return RecentLetterModel(
      id: json['id'],
      referenceNumber: json['reference_number'],
      subject: json['subject'] ?? '',
      status: json['status'] ?? 'draft',
      recipientName: json['recipient_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// نموذج معلومات الاشتراك
class SubscriptionInfoModel extends SubscriptionInfo {
  const SubscriptionInfoModel({
    required super.type,
    super.planName,
    super.remainingLetters,
    super.expiresAt,
    required super.isActive,
  });

  factory SubscriptionInfoModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfoModel(
      type: json['type'] ?? 'none',
      planName: json['plan_name'],
      remainingLetters: json['remaining_letters'],
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      isActive: json['is_active'] ?? false,
    );
  }
}
