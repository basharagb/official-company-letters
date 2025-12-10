import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

/// حالة استخدام جلب بيانات لوحة التحكم
class GetDashboardUseCase {
  final DashboardRepository _repository;

  GetDashboardUseCase(this._repository);

  Future<Either<Failure, DashboardStats>> call() {
    return _repository.getDashboard();
  }
}
