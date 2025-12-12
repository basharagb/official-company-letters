import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/letter.dart';

/// واجهة مستودع الخطابات
abstract class LettersRepository {
  /// جلب قائمة الخطابات
  Future<Either<Failure, List<Letter>>> getLetters({
    String? search,
    String? status,
    int page = 1,
  });

  /// جلب بيانات إنشاء خطاب
  Future<Either<Failure, CreateLetterData>> getCreateData();

  /// إنشاء خطاب جديد
  Future<Either<Failure, Letter>> createLetter(Map<String, dynamic> data);

  /// جلب خطاب محدد
  Future<Either<Failure, Letter>> getLetter(int id);

  /// تحديث خطاب
  Future<Either<Failure, Letter>> updateLetter(
    int id,
    Map<String, dynamic> data,
  );

  /// حذف خطاب
  Future<Either<Failure, void>> deleteLetter(int id);

  /// إصدار خطاب
  Future<Either<Failure, Letter>> issueLetter(int id);

  /// جلب رابط PDF
  Future<Either<Failure, String>> getPdfUrl(int id);

  /// جلب رابط المشاركة
  Future<Either<Failure, String>> getShareLink(int id);

  /// إرسال الخطاب بالبريد
  Future<Either<Failure, void>> sendEmail(int id, String email);
}
