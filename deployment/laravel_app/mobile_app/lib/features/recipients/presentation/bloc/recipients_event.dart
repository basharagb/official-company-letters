part of 'recipients_bloc.dart';

abstract class RecipientsEvent extends Equatable {
  const RecipientsEvent();
  @override
  List<Object?> get props => [];
}

class LoadRecipientsEvent extends RecipientsEvent {}

class CreateRecipientEvent extends RecipientsEvent {
  final Map<String, dynamic> data;
  const CreateRecipientEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeleteRecipientEvent extends RecipientsEvent {
  final int id;
  const DeleteRecipientEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
