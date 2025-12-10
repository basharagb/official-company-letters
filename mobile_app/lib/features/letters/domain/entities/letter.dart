import 'package:equatable/equatable.dart';

/// كيان الخطاب
class Letter extends Equatable {
  final int id;
  final String? referenceNumber;
  final String subject;
  final String content;
  final String status;
  final String? recipientName;
  final String? recipientTitle;
  final String? organizationName;
  final int? templateId;
  final String? templateName;
  final String? gregorianDate;
  final String? hijriDate;
  final String? pdfPath;
  final String? shareToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Letter({
    required this.id,
    this.referenceNumber,
    required this.subject,
    required this.content,
    required this.status,
    this.recipientName,
    this.recipientTitle,
    this.organizationName,
    this.templateId,
    this.templateName,
    this.gregorianDate,
    this.hijriDate,
    this.pdfPath,
    this.shareToken,
    required this.createdAt,
    required this.updatedAt,
  });

  /// هل الخطاب مسودة؟
  bool get isDraft => status == 'draft';

  /// هل الخطاب صادر؟
  bool get isIssued => status == 'issued';

  /// هل الخطاب مُرسل؟
  bool get isSent => status == 'sent';

  @override
  List<Object?> get props => [
    id,
    referenceNumber,
    subject,
    content,
    status,
    recipientName,
    recipientTitle,
    organizationName,
    templateId,
    templateName,
    gregorianDate,
    hijriDate,
    pdfPath,
    shareToken,
    createdAt,
    updatedAt,
  ];
}

/// بيانات إنشاء خطاب جديد
class CreateLetterData extends Equatable {
  final List<dynamic> templates;
  final List<dynamic> recipients;
  final List<dynamic> recipientTitles;
  final List<dynamic> organizations;
  final List<dynamic> letterSubjects;

  const CreateLetterData({
    required this.templates,
    required this.recipients,
    required this.recipientTitles,
    required this.organizations,
    required this.letterSubjects,
  });

  @override
  List<Object?> get props => [
    templates,
    recipients,
    recipientTitles,
    organizations,
    letterSubjects,
  ];
}
