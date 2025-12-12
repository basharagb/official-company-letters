import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/recipients_repository.dart';

part 'recipients_event.dart';
part 'recipients_state.dart';

class RecipientsBloc extends Bloc<RecipientsEvent, RecipientsState> {
  final RecipientsRepository _repository;

  RecipientsBloc(this._repository) : super(RecipientsInitial()) {
    on<LoadRecipientsEvent>(_onLoadRecipients);
    on<CreateRecipientEvent>(_onCreateRecipient);
    on<DeleteRecipientEvent>(_onDeleteRecipient);
  }

  Future<void> _onLoadRecipients(
    LoadRecipientsEvent event,
    Emitter<RecipientsState> emit,
  ) async {
    emit(RecipientsLoading());
    final result = await _repository.getRecipients();
    result.fold(
      (failure) => emit(RecipientsError(message: failure.message)),
      (recipients) => emit(RecipientsLoaded(recipients: recipients)),
    );
  }

  Future<void> _onCreateRecipient(
    CreateRecipientEvent event,
    Emitter<RecipientsState> emit,
  ) async {
    emit(RecipientsLoading());
    final result = await _repository.createRecipient(event.data);
    result.fold(
      (failure) => emit(RecipientsError(message: failure.message)),
      (_) => add(LoadRecipientsEvent()),
    );
  }

  Future<void> _onDeleteRecipient(
    DeleteRecipientEvent event,
    Emitter<RecipientsState> emit,
  ) async {
    final result = await _repository.deleteRecipient(event.id);
    result.fold(
      (failure) => emit(RecipientsError(message: failure.message)),
      (_) => add(LoadRecipientsEvent()),
    );
  }
}
