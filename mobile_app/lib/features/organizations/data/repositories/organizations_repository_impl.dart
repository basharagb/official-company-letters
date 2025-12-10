import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/organizations_repository.dart';
import '../datasources/organizations_remote_datasource.dart';

class OrganizationsRepositoryImpl implements OrganizationsRepository {
  final OrganizationsRemoteDataSource _remoteDataSource;
  OrganizationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getOrganizations() async {
    try {
      final result = await _remoteDataSource.getOrganizations();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getActiveOrganizations() async {
    try {
      final result = await _remoteDataSource.getActiveOrganizations();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createOrganization(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.createOrganization(data);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrganization(int id) async {
    try {
      await _remoteDataSource.deleteOrganization(id);
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
