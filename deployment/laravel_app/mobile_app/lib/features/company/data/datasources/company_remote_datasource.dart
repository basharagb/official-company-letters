import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

/// مصدر بيانات الشركة عن بعد
abstract class CompanyRemoteDataSource {
  Future<Map<String, dynamic>> getCompany();
  Future<Map<String, dynamic>> updateCompany(Map<String, dynamic> data);
  Future<String> uploadLogo(String filePath);
  Future<String> uploadSignature(String filePath);
  Future<String> uploadStamp(String filePath);
  Future<void> deleteLogo();
  Future<void> deleteSignature();
  Future<void> deleteStamp();
  // إعدادات الورق الرسمي
  Future<Map<String, dynamic>> getLetterheadSettings();
  Future<Map<String, dynamic>> updateLetterheadSettings(
      Map<String, dynamic> data);
  Future<String> uploadLetterhead(String filePath);
  Future<void> deleteLetterhead();
  // الإعداد الأولي
  Future<Map<String, dynamic>> getSetupStatus();
  Future<Map<String, dynamic>> completeSetup(Map<String, dynamic> data);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final ApiClient _apiClient;

  CompanyRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> getCompany() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.company);
      if (response.statusCode == 200) {
        return response.data['company'] ?? response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل جلب بيانات الشركة',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateCompany(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(ApiEndpoints.company, data: data);
      if (response.statusCode == 200) {
        return response.data['company'] ?? response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل تحديث بيانات الشركة',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> uploadLogo(String filePath) async {
    try {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.companyLogo,
        filePath: filePath,
        fieldName: 'logo',
      );
      if (response.statusCode == 200) {
        return response.data['url'] ?? '';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل رفع الشعار',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> uploadSignature(String filePath) async {
    try {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.companySignature,
        filePath: filePath,
        fieldName: 'signature',
      );
      if (response.statusCode == 200) {
        return response.data['url'] ?? '';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل رفع التوقيع',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> uploadStamp(String filePath) async {
    try {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.companyStamp,
        filePath: filePath,
        fieldName: 'stamp',
      );
      if (response.statusCode == 200) {
        return response.data['url'] ?? '';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل رفع الختم',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteLogo() async {
    await _apiClient.delete(ApiEndpoints.companyLogo);
  }

  @override
  Future<void> deleteSignature() async {
    await _apiClient.delete(ApiEndpoints.companySignature);
  }

  @override
  Future<void> deleteStamp() async {
    await _apiClient.delete(ApiEndpoints.companyStamp);
  }

  @override
  Future<Map<String, dynamic>> getLetterheadSettings() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companyLetterhead);
      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل جلب إعدادات الورق الرسمي',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateLetterheadSettings(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _apiClient.put(ApiEndpoints.companyLetterhead, data: data);
      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل تحديث إعدادات الورق الرسمي',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> uploadLetterhead(String filePath) async {
    try {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.companyLetterhead,
        filePath: filePath,
        fieldName: 'letterhead_file',
      );
      if (response.statusCode == 200) {
        return response.data['data']?['letterhead_url'] ?? '';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل رفع الورق الرسمي',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteLetterhead() async {
    await _apiClient.delete(ApiEndpoints.companyLetterhead);
  }

  @override
  Future<Map<String, dynamic>> getSetupStatus() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companySetupStatus);
      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل جلب حالة الإعداد',
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> completeSetup(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.companyCompleteSetup, data: data);
      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'فشل إكمال الإعداد',
      );
    } on DioException {
      rethrow;
    }
  }
}
