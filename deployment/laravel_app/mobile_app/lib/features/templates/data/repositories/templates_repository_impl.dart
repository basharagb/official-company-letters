import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/templates_repository.dart';
import '../datasources/templates_remote_datasource.dart';

class TemplatesRepositoryImpl implements TemplatesRepository {
  final TemplatesRemoteDataSource _remoteDataSource;
  TemplatesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTemplates() async {
    try {
      final result = await _remoteDataSource.getTemplates();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getActiveTemplates() async {
    try {
      final result = await _remoteDataSource.getActiveTemplates();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTemplate(int id) async {
    try {
      final result = await _remoteDataSource.getTemplate(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createTemplate(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.createTemplate(data);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateTemplate(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.updateTemplate(id, data);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(int id) async {
    try {
      await _remoteDataSource.deleteTemplate(id);
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
