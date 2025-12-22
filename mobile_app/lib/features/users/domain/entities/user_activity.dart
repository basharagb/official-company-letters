import 'package:equatable/equatable.dart';

class UserActivity extends Equatable {
  final int id;
  final String type;
  final String action;
  final String description;
  final String? referenceNumber;
  final String? company;
  final String createdAt;
  final String? dateHijri;

  const UserActivity({
    required this.id,
    required this.type,
    required this.action,
    required this.description,
    this.referenceNumber,
    this.company,
    required this.createdAt,
    this.dateHijri,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        action,
        description,
        referenceNumber,
        company,
        createdAt,
        dateHijri,
      ];
}
