import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class SubscriptionsRepository {
  Future<Either<Failure, Map<String, dynamic>>> getCurrentSubscription();
  Future<Either<Failure, List<Map<String, dynamic>>>> getPlans();
  Future<Either<Failure, Map<String, dynamic>>> subscribe(
    int planId, {
    String? paymentMethod,
  });
  Future<Either<Failure, void>> cancelSubscription();
  Future<Either<Failure, List<Map<String, dynamic>>>> getPaymentHistory();
}
