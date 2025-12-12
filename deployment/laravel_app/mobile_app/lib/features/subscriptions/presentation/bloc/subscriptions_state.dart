part of 'subscriptions_bloc.dart';

abstract class SubscriptionsState extends Equatable {
  const SubscriptionsState();
  @override
  List<Object?> get props => [];
}

class SubscriptionsInitial extends SubscriptionsState {}

class SubscriptionsLoading extends SubscriptionsState {}

class SubscriptionLoaded extends SubscriptionsState {
  final Map<String, dynamic> subscription;
  const SubscriptionLoaded({required this.subscription});
  @override
  List<Object?> get props => [subscription];
}

class PlansLoaded extends SubscriptionsState {
  final List<Map<String, dynamic>> plans;
  const PlansLoaded({required this.plans});
  @override
  List<Object?> get props => [plans];
}

class SubscriptionSuccess extends SubscriptionsState {
  final Map<String, dynamic> subscription;
  const SubscriptionSuccess({required this.subscription});
  @override
  List<Object?> get props => [subscription];
}

class SubscriptionCancelled extends SubscriptionsState {}

class SubscriptionsError extends SubscriptionsState {
  final String message;
  const SubscriptionsError({required this.message});
  @override
  List<Object?> get props => [message];
}
