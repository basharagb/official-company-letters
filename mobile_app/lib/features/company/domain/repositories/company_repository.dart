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

  // Letterhead methods
  Future<Either<Failure, String>> uploadLetterhead(String filePath);
  Future<Either<Failure, Map<String, dynamic>>> updateLetterheadSettings(
    Map<String, dynamic> settings,
  );
  Future<Either<Failure, Map<String, dynamic>>> getLetterheadSettings();
  Future<Either<Failure, void>> deleteLetterhead();
}
