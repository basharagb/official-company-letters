part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();
  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final Map<String, dynamic> company;
  const CompanyLoaded({required this.company});
  @override
  List<Object?> get props => [company];
}

class CompanyUpdating extends CompanyState {}

class CompanyUpdated extends CompanyState {
  final Map<String, dynamic> company;
  const CompanyUpdated({required this.company});
  @override
  List<Object?> get props => [company];
}

class CompanyUploading extends CompanyState {
  final String type;
  const CompanyUploading({required this.type});
  @override
  List<Object?> get props => [type];
}

class CompanyUploaded extends CompanyState {
  final String type;
  final String url;
  const CompanyUploaded({required this.type, required this.url});
  @override
  List<Object?> get props => [type, url];
}

class CompanyError extends CompanyState {
  final String message;
  const CompanyError({required this.message});
  @override
  List<Object?> get props => [message];
}

class CompanyLetterheadSetupCompleted extends CompanyState {
  final Map<String, dynamic> company;
  const CompanyLetterheadSetupCompleted({required this.company});
  @override
  List<Object?> get props => [company];
}
