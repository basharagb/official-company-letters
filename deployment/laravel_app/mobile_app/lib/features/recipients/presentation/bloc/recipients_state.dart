part of 'recipients_bloc.dart';

abstract class RecipientsState extends Equatable {
  const RecipientsState();
  @override
  List<Object?> get props => [];
}

class RecipientsInitial extends RecipientsState {}

class RecipientsLoading extends RecipientsState {}

class RecipientsLoaded extends RecipientsState {
  final List<Map<String, dynamic>> recipients;
  const RecipientsLoaded({required this.recipients});
  @override
  List<Object?> get props => [recipients];
}

class RecipientsError extends RecipientsState {
  final String message;
  const RecipientsError({required this.message});
  @override
  List<Object?> get props => [message];
}
