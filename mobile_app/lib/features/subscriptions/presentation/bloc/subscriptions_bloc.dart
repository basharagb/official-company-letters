import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/subscriptions_repository.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final SubscriptionsRepository _repository;

  SubscriptionsBloc(this._repository) : super(SubscriptionsInitial()) {
    on<LoadSubscriptionEvent>(_onLoadSubscription);
    on<LoadPlansEvent>(_onLoadPlans);
    on<SubscribeEvent>(_onSubscribe);
    on<CancelSubscriptionEvent>(_onCancelSubscription);
  }

  Future<void> _onLoadSubscription(
    LoadSubscriptionEvent event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(SubscriptionsLoading());
    final result = await _repository.getCurrentSubscription();
    result.fold(
      (failure) => emit(SubscriptionsError(message: failure.message)),
      (subscription) => emit(SubscriptionLoaded(subscription: subscription)),
    );
  }

  Future<void> _onLoadPlans(
    LoadPlansEvent event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(SubscriptionsLoading());
    final result = await _repository.getPlans();
    result.fold(
      (failure) => emit(SubscriptionsError(message: failure.message)),
      (plans) => emit(PlansLoaded(plans: plans)),
    );
  }

  Future<void> _onSubscribe(
    SubscribeEvent event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(SubscriptionsLoading());
    final result = await _repository.subscribe(
      event.planId,
      paymentMethod: event.paymentMethod,
    );
    result.fold(
      (failure) => emit(SubscriptionsError(message: failure.message)),
      (subscription) => emit(SubscriptionSuccess(subscription: subscription)),
    );
  }

  Future<void> _onCancelSubscription(
    CancelSubscriptionEvent event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(SubscriptionsLoading());
    final result = await _repository.cancelSubscription();
    result.fold(
      (failure) => emit(SubscriptionsError(message: failure.message)),
      (_) => emit(SubscriptionCancelled()),
    );
  }
}
