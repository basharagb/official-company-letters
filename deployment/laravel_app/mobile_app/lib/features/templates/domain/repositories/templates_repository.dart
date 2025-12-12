import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class TemplatesRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getTemplates();
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveTemplates();
  Future<Either<Failure, Map<String, dynamic>>> getTemplate(int id);
  Future<Either<Failure, Map<String, dynamic>>> createTemplate(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, Map<String, dynamic>>> updateTemplate(
    int id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deleteTemplate(int id);
  Future<Either<Failure, void>> toggleActive(int id);
}
