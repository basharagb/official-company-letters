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

class CompleteLetterheadSetupEvent extends CompanyEvent {
  final File? letterheadFile;
  final String barcodePosition;
  final bool showBarcode;
  final bool showReferenceNumber;
  final bool showHijriDate;
  final bool showGregorianDate;
  final bool showSubject;
  final double topMargin;
  final double sideMargin;

  const CompleteLetterheadSetupEvent({
    this.letterheadFile,
    required this.barcodePosition,
    required this.showBarcode,
    required this.showReferenceNumber,
    required this.showHijriDate,
    required this.showGregorianDate,
    required this.showSubject,
    required this.topMargin,
    required this.sideMargin,
  });

  @override
  List<Object?> get props => [
        letterheadFile,
        barcodePosition,
        showBarcode,
        showReferenceNumber,
        showHijriDate,
        showGregorianDate,
        showSubject,
        topMargin,
        sideMargin,
      ];
}
