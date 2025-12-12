import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/letter.dart';
import '../repositories/letters_repository.dart';

/// حالة استخدام إنشاء خطاب
class CreateLetterUseCase {
  final LettersRepository _repository;

  CreateLetterUseCase(this._repository);

  Future<Either<Failure, Letter>> call(Map<String, dynamic> data) {
    return _repository.createLetter(data);
  }
}
