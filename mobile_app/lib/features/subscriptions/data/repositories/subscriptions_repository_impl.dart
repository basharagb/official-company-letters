import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/subscriptions_repository.dart';
import '../datasources/subscriptions_remote_datasource.dart';

class SubscriptionsRepositoryImpl implements SubscriptionsRepository {
  final SubscriptionsRemoteDataSource _remoteDataSource;
  SubscriptionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCurrentSubscription() async {
    try {
      final result = await _remoteDataSource.getCurrentSubscription();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPlans() async {
    try {
      final result = await _remoteDataSource.getPlans();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> subscribe(
    int planId, {
    String? paymentMethod,
  }) async {
    try {
      final result = await _remoteDataSource.subscribe(
        planId,
        paymentMethod: paymentMethod,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription() async {
    try {
      await _remoteDataSource.cancelSubscription();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getPaymentHistory() async {
    try {
      final result = await _remoteDataSource.getPaymentHistory();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
