import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class OrganizationsRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getOrganizations();
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveOrganizations();
  Future<Either<Failure, Map<String, dynamic>>> createOrganization(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deleteOrganization(int id);
  Future<Either<Failure, void>> toggleActive(int id);
}
