import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UsersEvent {
  final int? page;
  final String? search;
  final int? companyId;
  final String? status;

  const LoadUsersEvent({
    this.page,
    this.search,
    this.companyId,
    this.status,
  });

  @override
  List<Object?> get props => [page, search, companyId, status];
}

class LoadUserDetailsEvent extends UsersEvent {
  final int userId;

  const LoadUserDetailsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserEvent extends UsersEvent {
  final int userId;
  final Map<String, dynamic> data;

  const UpdateUserEvent(this.userId, this.data);

  @override
  List<Object?> get props => [userId, data];
}

class DeleteUserEvent extends UsersEvent {
  final int userId;

  const DeleteUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserActivityLogEvent extends UsersEvent {
  final int userId;
  final int? page;

  const LoadUserActivityLogEvent(this.userId, {this.page});

  @override
  List<Object?> get props => [userId, page];
}

class LoadCompaniesEvent extends UsersEvent {
  const LoadCompaniesEvent();
}

class UpdateUserStatusEvent extends UsersEvent {
  final int userId;
  final String status;

  const UpdateUserStatusEvent(this.userId, this.status);

  @override
  List<Object?> get props => [userId, status];
}

class RefreshUsersEvent extends UsersEvent {
  const RefreshUsersEvent();
}
