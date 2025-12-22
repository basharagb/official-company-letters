import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_activity.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final int currentPage;
  final int lastPage;
  final int total;

  const UsersLoaded({
    required this.users,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [users, currentPage, lastPage, total];
}

class UserDetailsLoaded extends UsersState {
  final UserEntity user;

  const UserDetailsLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserActivityLogLoaded extends UsersState {
  final UserEntity user;
  final List<UserActivity> activities;
  final int currentPage;
  final int lastPage;
  final int total;

  const UserActivityLogLoaded({
    required this.user,
    required this.activities,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [user, activities, currentPage, lastPage, total];
}

class CompaniesLoaded extends UsersState {
  final List<Map<String, dynamic>> companies;

  const CompaniesLoaded(this.companies);

  @override
  List<Object?> get props => [companies];
}

class UserOperationSuccess extends UsersState {
  final String message;

  const UserOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}
