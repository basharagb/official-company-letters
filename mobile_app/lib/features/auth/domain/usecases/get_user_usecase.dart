import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// حالة استخدام جلب بيانات المستخدم
class GetUserUseCase {
  final AuthRepository _repository;

  GetUserUseCase(this._repository);

  Future<Either<Failure, User>> call() {
    return _repository.getUser();
  }
}
