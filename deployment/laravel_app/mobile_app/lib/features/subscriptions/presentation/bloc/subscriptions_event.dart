part of 'subscriptions_bloc.dart';

abstract class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSubscriptionEvent extends SubscriptionsEvent {}

class LoadPlansEvent extends SubscriptionsEvent {}

class SubscribeEvent extends SubscriptionsEvent {
  final int planId;
  final String? paymentMethod;
  const SubscribeEvent({required this.planId, this.paymentMethod});
  @override
  List<Object?> get props => [planId, paymentMethod];
}

class CancelSubscriptionEvent extends SubscriptionsEvent {}
