import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/letter.dart';
import '../repositories/letters_repository.dart';

/// حالة استخدام جلب الخطابات
class GetLettersUseCase {
  final LettersRepository _repository;

  GetLettersUseCase(this._repository);

  Future<Either<Failure, List<Letter>>> call({
    String? search,
    String? status,
    int page = 1,
  }) {
    return _repository.getLetters(search: search, status: status, page: page);
  }
}
