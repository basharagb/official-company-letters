import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/organizations_repository.dart';

part 'organizations_event.dart';
part 'organizations_state.dart';

class OrganizationsBloc extends Bloc<OrganizationsEvent, OrganizationsState> {
  final OrganizationsRepository _repository;

  OrganizationsBloc(this._repository) : super(OrganizationsInitial()) {
    on<LoadOrganizationsEvent>(_onLoadOrganizations);
    on<CreateOrganizationEvent>(_onCreateOrganization);
    on<DeleteOrganizationEvent>(_onDeleteOrganization);
  }

  Future<void> _onLoadOrganizations(
    LoadOrganizationsEvent event,
    Emitter<OrganizationsState> emit,
  ) async {
    emit(OrganizationsLoading());
    final result = await _repository.getOrganizations();
    result.fold(
      (failure) => emit(OrganizationsError(message: failure.message)),
      (organizations) =>
          emit(OrganizationsLoaded(organizations: organizations)),
    );
  }

  Future<void> _onCreateOrganization(
    CreateOrganizationEvent event,
    Emitter<OrganizationsState> emit,
  ) async {
    emit(OrganizationsLoading());
    final result = await _repository.createOrganization(event.data);
    result.fold(
      (failure) => emit(OrganizationsError(message: failure.message)),
      (_) => add(LoadOrganizationsEvent()),
    );
  }

  Future<void> _onDeleteOrganization(
    DeleteOrganizationEvent event,
    Emitter<OrganizationsState> emit,
  ) async {
    final result = await _repository.deleteOrganization(event.id);
    result.fold(
      (failure) => emit(OrganizationsError(message: failure.message)),
      (_) => add(LoadOrganizationsEvent()),
    );
  }
}
