import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class RecipientsRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getRecipients();
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveRecipients();
  Future<Either<Failure, Map<String, dynamic>>> createRecipient(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deleteRecipient(int id);
  Future<Either<Failure, void>> toggleActive(int id);
}
