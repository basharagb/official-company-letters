import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/dashboard_stats.dart';

/// واجهة مستودع لوحة التحكم
abstract class DashboardRepository {
  /// جلب إحصائيات لوحة التحكم
  Future<Either<Failure, DashboardStats>> getDashboard();

  /// جلب إحصائيات سريعة
  Future<Either<Failure, Map<String, dynamic>>> getQuickStats();
}
