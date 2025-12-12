import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class CompanyRepository {
  Future<Either<Failure, Map<String, dynamic>>> getCompany();
  Future<Either<Failure, Map<String, dynamic>>> updateCompany(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, String>> uploadLogo(String filePath);
  Future<Either<Failure, String>> uploadSignature(String filePath);
  Future<Either<Failure, String>> uploadStamp(String filePath);
  Future<Either<Failure, void>> deleteLogo();
  Future<Either<Failure, void>> deleteSignature();
  Future<Either<Failure, void>> deleteStamp();
}
