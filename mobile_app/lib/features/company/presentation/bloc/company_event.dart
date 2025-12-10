part of 'company_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
  @override
  List<Object?> get props => [];
}

class LoadCompanyEvent extends CompanyEvent {}

class UpdateCompanyEvent extends CompanyEvent {
  final Map<String, dynamic> data;
  const UpdateCompanyEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class UploadLogoEvent extends CompanyEvent {
  final String filePath;
  const UploadLogoEvent({required this.filePath});
  @override
  List<Object?> get props => [filePath];
}

class UploadSignatureEvent extends CompanyEvent {
  final String filePath;
  const UploadSignatureEvent({required this.filePath});
  @override
  List<Object?> get props => [filePath];
}

class UploadStampEvent extends CompanyEvent {
  final String filePath;
  const UploadStampEvent({required this.filePath});
  @override
  List<Object?> get props => [filePath];
}
