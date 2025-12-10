import 'package:equatable/equatable.dart';

/// كيان إحصائيات لوحة التحكم
class DashboardStats extends Equatable {
  final String userName;
  final String? companyName;
  final int totalLetters;
  final int draftLetters;
  final int issuedLetters;
  final int sentLetters;
  final int totalTemplates;
  final int totalRecipients;
  final int totalOrganizations;
  final List<RecentLetter> recentLetters;
  final SubscriptionInfo? subscription;

  const DashboardStats({
    required this.userName,
    this.companyName,
    required this.totalLetters,
    required this.draftLetters,
    required this.issuedLetters,
    required this.sentLetters,
    required this.totalTemplates,
    required this.totalRecipients,
    required this.totalOrganizations,
    required this.recentLetters,
    this.subscription,
  });

  @override
  List<Object?> get props => [
        userName,
        companyName,
        totalLetters,
        draftLetters,
        issuedLetters,
        sentLetters,
        totalTemplates,
        totalRecipients,
        totalOrganizations,
        recentLetters,
        subscription,
      ];
}

/// خطاب حديث
class RecentLetter extends Equatable {
  final int id;
  final String? referenceNumber;
  final String subject;
  final String status;
  final String? recipientName;
  final DateTime createdAt;

  const RecentLetter({
    required this.id,
    this.referenceNumber,
    required this.subject,
    required this.status,
    this.recipientName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        referenceNumber,
        subject,
        status,
        recipientName,
        createdAt,
      ];
}

/// معلومات الاشتراك
class SubscriptionInfo extends Equatable {
  final String type;
  final String? planName;
  final int? remainingLetters;
  final DateTime? expiresAt;
  final bool isActive;

  const SubscriptionInfo({
    required this.type,
    this.planName,
    this.remainingLetters,
    this.expiresAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        type,
        planName,
        remainingLetters,
        expiresAt,
        isActive,
      ];
}
