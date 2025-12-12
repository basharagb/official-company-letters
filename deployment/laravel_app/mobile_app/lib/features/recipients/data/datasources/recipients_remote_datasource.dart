import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

abstract class RecipientsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getRecipients();
  Future<List<Map<String, dynamic>>> getActiveRecipients();
  Future<Map<String, dynamic>> createRecipient(Map<String, dynamic> data);
  Future<void> deleteRecipient(int id);
  Future<void> toggleActive(int id);
}

class RecipientsRemoteDataSourceImpl implements RecipientsRemoteDataSource {
  final ApiClient _apiClient;
  RecipientsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getRecipients() async {
    final response = await _apiClient.get(ApiEndpoints.recipients);
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب المستلمين',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveRecipients() async {
    final response = await _apiClient.get(ApiEndpoints.recipientsActive);
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب المستلمين النشطين',
    );
  }

  @override
  Future<Map<String, dynamic>> createRecipient(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post(ApiEndpoints.recipients, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['recipient'] ?? response.data;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل إنشاء المستلم',
    );
  }

  @override
  Future<void> deleteRecipient(int id) async {
    await _apiClient.delete(ApiEndpoints.recipientById(id));
  }

  @override
  Future<void> toggleActive(int id) async {
    await _apiClient.post(ApiEndpoints.toggleRecipient(id));
  }
}
