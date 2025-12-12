import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_remote_datasource.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource _remoteDataSource;

  CompanyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCompany() async {
    try {
      final result = await _remoteDataSource.getCompany();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateCompany(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.updateCompany(data);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogo(String filePath) async {
    try {
      final result = await _remoteDataSource.uploadLogo(filePath);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadSignature(String filePath) async {
    try {
      final result = await _remoteDataSource.uploadSignature(filePath);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadStamp(String filePath) async {
    try {
      final result = await _remoteDataSource.uploadStamp(filePath);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLogo() async {
    try {
      await _remoteDataSource.deleteLogo();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSignature() async {
    try {
      await _remoteDataSource.deleteSignature();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStamp() async {
    try {
      await _remoteDataSource.deleteStamp();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLetterhead(String filePath) async {
    try {
      final result = await _remoteDataSource.uploadLetterhead(filePath);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateLetterheadSettings(
    Map<String, dynamic> settings,
  ) async {
    try {
      final result = await _remoteDataSource.updateLetterheadSettings(settings);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLetterheadSettings() async {
    try {
      final result = await _remoteDataSource.getLetterheadSettings();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLetterhead() async {
    try {
      await _remoteDataSource.deleteLetterhead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'خطأ في السيرفر'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
