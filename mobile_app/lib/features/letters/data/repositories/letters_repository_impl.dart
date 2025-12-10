import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/letter.dart';
import '../../domain/repositories/letters_repository.dart';
import '../datasources/letters_remote_datasource.dart';

/// تنفيذ مستودع الخطابات
class LettersRepositoryImpl implements LettersRepository {
  final LettersRemoteDataSource _remoteDataSource;

  LettersRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Letter>>> getLetters({
    String? search,
    String? status,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getLetters(
        search: search,
        status: status,
        page: page,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateLetterData>> getCreateData() async {
    try {
      final result = await _remoteDataSource.getCreateData();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Letter>> createLetter(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.createLetter(data);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Letter>> getLetter(int id) async {
    try {
      final result = await _remoteDataSource.getLetter(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Letter>> updateLetter(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.updateLetter(id, data);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLetter(int id) async {
    try {
      await _remoteDataSource.deleteLetter(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Letter>> issueLetter(int id) async {
    try {
      final result = await _remoteDataSource.issueLetter(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getPdfUrl(int id) async {
    try {
      final result = await _remoteDataSource.getPdfUrl(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getShareLink(int id) async {
    try {
      final result = await _remoteDataSource.getShareLink(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmail(int id, String email) async {
    try {
      await _remoteDataSource.sendEmail(id, email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionFailure(message: 'انتهت مهلة الاتصال');
      case DioExceptionType.connectionError:
        return const ConnectionFailure();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'حدث خطأ في السيرفر';
        return ServerFailure(message: message, statusCode: statusCode);
      default:
        return UnknownFailure(message: e.message ?? 'حدث خطأ غير متوقع');
    }
  }
}
