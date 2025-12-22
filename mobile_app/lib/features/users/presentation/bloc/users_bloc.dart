import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/users_repository.dart';
import '../../data/models/user_model.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository repository;

  UsersBloc({required this.repository}) : super(UsersInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<LoadUserDetailsEvent>(_onLoadUserDetails);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<LoadUserActivityLogEvent>(_onLoadUserActivityLog);
    on<LoadCompaniesEvent>(_onLoadCompanies);
    on<UpdateUserStatusEvent>(_onUpdateUserStatus);
    on<RefreshUsersEvent>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    final result = await repository.getUsers(
      page: event.page,
      search: event.search,
      companyId: event.companyId,
      status: event.status,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (data) {
        final users = (data['data'] as List)
            .map((json) => UserModel.fromJson(json))
            .toList();

        emit(UsersLoaded(
          users: users,
          currentPage: data['current_page'] as int,
          lastPage: data['last_page'] as int,
          total: data['total'] as int,
        ));
      },
    );
  }

  Future<void> _onLoadUserDetails(
    LoadUserDetailsEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    final result = await repository.getUserDetails(event.userId);

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (user) => emit(UserDetailsLoaded(user)),
    );
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    final result = await repository.updateUser(event.userId, event.data);

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (user) => emit(UserOperationSuccess('تم تحديث المستخدم بنجاح')),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    final result = await repository.deleteUser(event.userId);

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => emit(const UserOperationSuccess('تم حذف المستخدم بنجاح')),
    );
  }

  Future<void> _onLoadUserActivityLog(
    LoadUserActivityLogEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    final result = await repository.getUserActivityLog(
      event.userId,
      page: event.page,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (data) {
        final user = UserModel.fromJson(data['user']);
        final activities = data['activities'] as List;
        final pagination = data['pagination'] as Map<String, dynamic>;

        emit(UserActivityLogLoaded(
          user: user,
          activities: activities.cast(),
          currentPage: pagination['current_page'] as int,
          lastPage: pagination['last_page'] as int,
          total: pagination['total'] as int,
        ));
      },
    );
  }

  Future<void> _onLoadCompanies(
    LoadCompaniesEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await repository.getCompanies();

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (companies) => emit(CompaniesLoaded(companies)),
    );
  }

  Future<void> _onUpdateUserStatus(
    UpdateUserStatusEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    final result =
        await repository.updateUserStatus(event.userId, event.status);

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (user) =>
          emit(const UserOperationSuccess('تم تحديث حالة المستخدم بنجاح')),
    );
  }

  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    add(const LoadUsersEvent());
  }
}
