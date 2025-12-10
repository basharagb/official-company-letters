import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

abstract class SubscriptionsRemoteDataSource {
  Future<Map<String, dynamic>> getCurrentSubscription();
  Future<List<Map<String, dynamic>>> getPlans();
  Future<Map<String, dynamic>> subscribe(int planId, {String? paymentMethod});
  Future<void> cancelSubscription();
  Future<List<Map<String, dynamic>>> getPaymentHistory();
}

class SubscriptionsRemoteDataSourceImpl
    implements SubscriptionsRemoteDataSource {
  final ApiClient _apiClient;
  SubscriptionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> getCurrentSubscription() async {
    final response = await _apiClient.get(ApiEndpoints.subscriptionCurrent);
    if (response.statusCode == 200) {
      return response.data['subscription'] ?? response.data;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب الاشتراك',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getPlans() async {
    final response = await _apiClient.get(ApiEndpoints.subscriptionPlans);
    if (response.statusCode == 200) {
      final data = response.data['plans'] ?? response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب الخطط',
    );
  }

  @override
  Future<Map<String, dynamic>> subscribe(
    int planId, {
    String? paymentMethod,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.subscribe,
      data: {
        'plan_id': planId,
        if (paymentMethod != null) 'payment_method': paymentMethod,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['subscription'] ?? response.data;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل الاشتراك',
    );
  }

  @override
  Future<void> cancelSubscription() async {
    await _apiClient.post(ApiEndpoints.cancelSubscription);
  }

  @override
  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    final response = await _apiClient.get(ApiEndpoints.subscriptionHistory);
    if (response.statusCode == 200) {
      final data = response.data['payments'] ??
          response.data['history'] ??
          response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب سجل المدفوعات',
    );
  }
}
