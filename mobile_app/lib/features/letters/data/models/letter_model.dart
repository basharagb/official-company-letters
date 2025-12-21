import '../../domain/entities/letter.dart';

/// نموذج الخطاب
class LetterModel extends Letter {
  const LetterModel({
    required super.id,
    super.referenceNumber,
    required super.subject,
    required super.content,
    required super.status,
    super.recipientName,
    super.recipientTitle,
    super.organizationName,
    super.templateId,
    super.templateName,
    super.gregorianDate,
    super.hijriDate,
    super.pdfPath,
    super.shareToken,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LetterModel.fromJson(Map<String, dynamic> json) {
    return LetterModel(
      id: _parseInt(json['id']),
      referenceNumber: json['reference_number'],
      subject: json['subject'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] ?? 'draft',
      recipientName: json['recipient_name'],
      recipientTitle: json['recipient_title'],
      organizationName:
          json['recipient_organization'] ?? json['organization_name'],
      templateId: _parseIntOrNull(json['template_id']),
      templateName: json['template_name'],
      gregorianDate: json['gregorian_date'],
      hijriDate: json['hijri_date'],
      pdfPath: json['pdf_path'],
      shareToken: json['share_token'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _parseIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference_number': referenceNumber,
      'subject': subject,
      'content': content,
      'status': status,
      'recipient_name': recipientName,
      'recipient_title': recipientTitle,
      'organization_name': organizationName,
      'template_id': templateId,
      'template_name': templateName,
      'gregorian_date': gregorianDate,
      'hijri_date': hijriDate,
      'pdf_path': pdfPath,
      'share_token': shareToken,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج بيانات إنشاء خطاب
class CreateLetterDataModel extends CreateLetterData {
  const CreateLetterDataModel({
    required super.templates,
    required super.recipients,
    required super.recipientTitles,
    required super.organizations,
    required super.letterSubjects,
  });

  factory CreateLetterDataModel.fromJson(Map<String, dynamic> json) {
    return CreateLetterDataModel(
      templates: json['templates'] ?? [],
      recipients: json['recipients'] ?? [],
      recipientTitles: json['recipient_titles'] ?? [],
      organizations: json['organizations'] ?? [],
      letterSubjects: json['letter_subjects'] ?? [],
    );
  }
}
