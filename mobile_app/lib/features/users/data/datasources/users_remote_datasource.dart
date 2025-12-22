import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<Map<String, dynamic>> getUsers({
    int? page,
    int? perPage,
    String? search,
    int? companyId,
    String? status,
  });
  Future<UserModel> getUserDetails(int id);
  Future<UserModel> updateUser(int id, Map<String, dynamic> data);
  Future<void> deleteUser(int id);
  Future<Map<String, dynamic>> getUserActivityLog(int id, {int? page});
  Future<List<Map<String, dynamic>>> getCompanies();
  Future<UserModel> updateUserStatus(int id, String status);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final Dio dio;

  UsersRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getUsers({
    int? page,
    int? perPage,
    String? search,
    int? companyId,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (companyId != null) queryParams['company_id'] = companyId;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;

    final response = await dio.get('/users', queryParameters: queryParams);

    if (response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw Exception(response.data['message'] ?? 'فشل في جلب المستخدمين');
    }
  }

  @override
  Future<UserModel> getUserDetails(int id) async {
    final response = await dio.get('/users/$id');

    if (response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'فشل في جلب بيانات المستخدم');
    }
  }

  @override
  Future<UserModel> updateUser(int id, Map<String, dynamic> data) async {
    final response = await dio.put('/users/$id', data: data);

    if (response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'فشل في تحديث المستخدم');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    final response = await dio.delete('/users/$id');

    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'فشل في حذف المستخدم');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserActivityLog(int id, {int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await dio.get(
      '/users/$id/activity-log',
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw Exception(response.data['message'] ?? 'فشل في جلب سجل النشاطات');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompanies() async {
    final response = await dio.get('/users/companies');

    if (response.data['success'] == true) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'فشل في جلب الشركات');
    }
  }

  @override
  Future<UserModel> updateUserStatus(int id, String status) async {
    final response =
        await dio.put('/users/$id/status', data: {'status': status});

    if (response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'فشل في تحديث حالة المستخدم');
    }
  }
}
