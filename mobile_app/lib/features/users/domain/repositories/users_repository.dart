import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, Map<String, dynamic>>> getUsers({
    int? page,
    int? perPage,
    String? search,
    int? companyId,
    String? status,
  });

  Future<Either<Failure, UserEntity>> getUserDetails(int id);

  Future<Either<Failure, UserEntity>> updateUser(
    int id,
    Map<String, dynamic> data,
  );

  Future<Either<Failure, void>> deleteUser(int id);

  Future<Either<Failure, Map<String, dynamic>>> getUserActivityLog(
    int id, {
    int? page,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getCompanies();

  Future<Either<Failure, UserEntity>> updateUserStatus(int id, String status);
}
