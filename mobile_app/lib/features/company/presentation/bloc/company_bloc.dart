import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/company_repository.dart';

part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository _repository;

  CompanyBloc(this._repository) : super(CompanyInitial()) {
    on<LoadCompanyEvent>(_onLoadCompany);
    on<UpdateCompanyEvent>(_onUpdateCompany);
    on<UploadLogoEvent>(_onUploadLogo);
    on<UploadSignatureEvent>(_onUploadSignature);
    on<UploadStampEvent>(_onUploadStamp);
    on<CompleteLetterheadSetupEvent>(_onCompleteLetterheadSetup);
  }

  Future<void> _onLoadCompany(
    LoadCompanyEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    final result = await _repository.getCompany();
    result.fold(
      (failure) => emit(CompanyError(message: failure.message)),
      (company) => emit(CompanyLoaded(company: company)),
    );
  }

  Future<void> _onUpdateCompany(
    UpdateCompanyEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyUpdating());
    final result = await _repository.updateCompany(event.data);
    result.fold(
      (failure) => emit(CompanyError(message: failure.message)),
      (company) => emit(CompanyUpdated(company: company)),
    );
  }

  Future<void> _onUploadLogo(
    UploadLogoEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyUploading(type: 'logo'));
    final result = await _repository.uploadLogo(event.filePath);
    result.fold(
      (failure) => emit(CompanyError(message: failure.message)),
      (url) => emit(CompanyUploaded(type: 'logo', url: url)),
    );
  }

  Future<void> _onUploadSignature(
    UploadSignatureEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyUploading(type: 'signature'));
    final result = await _repository.uploadSignature(event.filePath);
    result.fold(
      (failure) => emit(CompanyError(message: failure.message)),
      (url) => emit(CompanyUploaded(type: 'signature', url: url)),
    );
  }

  Future<void> _onUploadStamp(
    UploadStampEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyUploading(type: 'stamp'));
    final result = await _repository.uploadStamp(event.filePath);
    result.fold(
      (failure) => emit(CompanyError(message: failure.message)),
      (url) => emit(CompanyUploaded(type: 'stamp', url: url)),
    );
  }

  Future<void> _onCompleteLetterheadSetup(
    CompleteLetterheadSetupEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());

    // رفع الورق الرسمي إذا تم اختياره
    if (event.letterheadFile != null) {
      final uploadResult =
          await _repository.uploadLetterhead(event.letterheadFile!.path);
      uploadResult.fold(
        (failure) {
          emit(CompanyError(
              message: 'فشل في رفع الورق الرسمي: ${failure.message}'));
          return;
        },
        (url) {
          // تم رفع الملف بنجاح
        },
      );
    }

    // تحديث إعدادات الباركود
    final settingsData = {
      'barcode_position': event.barcodePosition,
      'show_barcode': event.showBarcode,
      'show_reference_number': event.showReferenceNumber,
      'show_hijri_date': event.showHijriDate,
      'show_gregorian_date': event.showGregorianDate,
      'show_subject_in_header': event.showSubject,
      'barcode_top_margin': event.topMargin,
      'barcode_side_margin': event.sideMargin,
    };

    final result = await _repository.updateLetterheadSettings(settingsData);
    result.fold(
      (failure) => emit(CompanyError(message: failure.message)),
      (company) => emit(CompanyLetterheadSetupCompleted(company: company)),
    );
  }
}
