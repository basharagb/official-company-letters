import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

abstract class TemplatesRemoteDataSource {
  Future<List<Map<String, dynamic>>> getTemplates();
  Future<List<Map<String, dynamic>>> getActiveTemplates();
  Future<Map<String, dynamic>> getTemplate(int id);
  Future<Map<String, dynamic>> createTemplate(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateTemplate(
    int id,
    Map<String, dynamic> data,
  );
  Future<void> deleteTemplate(int id);
  Future<void> toggleActive(int id);
}

class TemplatesRemoteDataSourceImpl implements TemplatesRemoteDataSource {
  final ApiClient _apiClient;
  TemplatesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getTemplates() async {
    final response = await _apiClient.get(ApiEndpoints.templates);
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب القوالب',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveTemplates() async {
    final response = await _apiClient.get(ApiEndpoints.templatesActive);
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب القوالب النشطة',
    );
  }

  @override
  Future<Map<String, dynamic>> getTemplate(int id) async {
    final response = await _apiClient.get(ApiEndpoints.templateById(id));
    if (response.statusCode == 200) {
      return response.data['template'] ?? response.data;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب القالب',
    );
  }

  @override
  Future<Map<String, dynamic>> createTemplate(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiEndpoints.templates, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['template'] ?? response.data;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل إنشاء القالب',
    );
  }

  @override
  Future<Map<String, dynamic>> updateTemplate(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.templateById(id),
      data: data,
    );
    if (response.statusCode == 200) {
      return response.data['template'] ?? response.data;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل تحديث القالب',
    );
  }

  @override
  Future<void> deleteTemplate(int id) async {
    await _apiClient.delete(ApiEndpoints.templateById(id));
  }

  @override
  Future<void> toggleActive(int id) async {
    await _apiClient.post(ApiEndpoints.toggleTemplate(id));
  }
}
