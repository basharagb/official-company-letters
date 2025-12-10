part of 'organizations_bloc.dart';

abstract class OrganizationsEvent extends Equatable {
  const OrganizationsEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrganizationsEvent extends OrganizationsEvent {}

class CreateOrganizationEvent extends OrganizationsEvent {
  final Map<String, dynamic> data;
  const CreateOrganizationEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeleteOrganizationEvent extends OrganizationsEvent {
  final int id;
  const DeleteOrganizationEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
