import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/recipients_repository.dart';
import '../datasources/recipients_remote_datasource.dart';

class RecipientsRepositoryImpl implements RecipientsRepository {
  final RecipientsRemoteDataSource _remoteDataSource;
  RecipientsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRecipients() async {
    try {
      final result = await _remoteDataSource.getRecipients();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getActiveRecipients() async {
    try {
      final result = await _remoteDataSource.getActiveRecipients();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createRecipient(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.createRecipient(data);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipient(int id) async {
    try {
      await _remoteDataSource.deleteRecipient(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleActive(int id) async {
    try {
      await _remoteDataSource.toggleActive(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
