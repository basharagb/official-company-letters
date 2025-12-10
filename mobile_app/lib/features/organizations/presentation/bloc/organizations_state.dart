part of 'organizations_bloc.dart';

abstract class OrganizationsState extends Equatable {
  const OrganizationsState();
  @override
  List<Object?> get props => [];
}

class OrganizationsInitial extends OrganizationsState {}

class OrganizationsLoading extends OrganizationsState {}

class OrganizationsLoaded extends OrganizationsState {
  final List<Map<String, dynamic>> organizations;
  const OrganizationsLoaded({required this.organizations});
  @override
  List<Object?> get props => [organizations];
}

class OrganizationsError extends OrganizationsState {
  final String message;
  const OrganizationsError({required this.message});
  @override
  List<Object?> get props => [message];
}
