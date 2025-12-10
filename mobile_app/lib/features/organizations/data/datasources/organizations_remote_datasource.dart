import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

abstract class OrganizationsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getOrganizations();
  Future<List<Map<String, dynamic>>> getActiveOrganizations();
  Future<Map<String, dynamic>> createOrganization(Map<String, dynamic> data);
  Future<void> deleteOrganization(int id);
  Future<void> toggleActive(int id);
}

class OrganizationsRemoteDataSourceImpl
    implements OrganizationsRemoteDataSource {
  final ApiClient _apiClient;
  OrganizationsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getOrganizations() async {
    final response = await _apiClient.get(ApiEndpoints.organizations);
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب الجهات',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveOrganizations() async {
    final response = await _apiClient.get(ApiEndpoints.organizationsActive);
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return List<Map<String, dynamic>>.from(data);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل جلب الجهات النشطة',
    );
  }

  @override
  Future<Map<String, dynamic>> createOrganization(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.organizations,
      data: data,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['organization'] ?? response.data;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'فشل إنشاء الجهة',
    );
  }

  @override
  Future<void> deleteOrganization(int id) async {
    await _apiClient.delete(ApiEndpoints.organizationById(id));
  }

  @override
  Future<void> toggleActive(int id) async {
    await _apiClient.post(ApiEndpoints.toggleOrganization(id));
  }
}
