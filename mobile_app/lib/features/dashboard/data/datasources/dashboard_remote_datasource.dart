import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats_model.dart';

/// مصدر بيانات لوحة التحكم عن بعد
abstract class DashboardRemoteDataSource {
  /// جلب إحصائيات لوحة التحكم
  Future<DashboardStatsModel> getDashboard();

  /// جلب إحصائيات سريعة
  Future<Map<String, dynamic>> getQuickStats();
}

/// تنفيذ مصدر بيانات لوحة التحكم
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient _apiClient;

  DashboardRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DashboardStatsModel> getDashboard() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.dashboard);

      if (response.statusCode == 200) {
        return DashboardStatsModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب بيانات لوحة التحكم',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getQuickStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.quickStats);

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب الإحصائيات السريعة',
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
