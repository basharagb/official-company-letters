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
}
