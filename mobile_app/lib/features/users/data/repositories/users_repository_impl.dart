import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_datasource.dart';
import '../models/user_activity_model.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUsers({
    int? page,
    int? perPage,
    String? search,
    int? companyId,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getUsers(
        page: page,
        perPage: perPage,
        search: search,
        companyId: companyId,
        status: status,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserDetails(int id) async {
    try {
      final result = await remoteDataSource.getUserDetails(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await remoteDataSource.updateUser(id, data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    try {
      await remoteDataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserActivityLog(
    int id, {
    int? page,
  }) async {
    try {
      final result = await remoteDataSource.getUserActivityLog(id, page: page);

      final activities = (result['activities'] as List)
          .map((json) => UserActivityModel.fromJson(json))
          .toList();

      return Right({
        'user': result['user'],
        'activities': activities,
        'pagination': result['pagination'],
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCompanies() async {
    try {
      final result = await remoteDataSource.getCompanies();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserStatus(
    int id,
    String status,
  ) async {
    try {
      final result = await remoteDataSource.updateUserStatus(id, status);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
