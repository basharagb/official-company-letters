import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/letter_model.dart';

/// مصدر بيانات الخطابات عن بعد
abstract class LettersRemoteDataSource {
  /// جلب قائمة الخطابات
  Future<List<LetterModel>> getLetters({
    String? search,
    String? status,
    int page = 1,
  });

  /// جلب بيانات إنشاء خطاب
  Future<CreateLetterDataModel> getCreateData();

  /// إنشاء خطاب جديد
  Future<LetterModel> createLetter(Map<String, dynamic> data);

  /// جلب خطاب محدد
  Future<LetterModel> getLetter(int id);

  /// تحديث خطاب
  Future<LetterModel> updateLetter(int id, Map<String, dynamic> data);

  /// حذف خطاب
  Future<void> deleteLetter(int id);

  /// إصدار خطاب
  Future<LetterModel> issueLetter(int id);

  /// جلب رابط PDF
  Future<String> getPdfUrl(int id);

  /// جلب رابط المشاركة
  Future<String> getShareLink(int id);

  /// إرسال الخطاب بالبريد
  Future<void> sendEmail(int id, String email);
}

/// تنفيذ مصدر بيانات الخطابات
class LettersRemoteDataSourceImpl implements LettersRemoteDataSource {
  final ApiClient _apiClient;

  LettersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<LetterModel>> getLetters({
    String? search,
    String? status,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
      };

      final response = await _apiClient.get(
        ApiEndpoints.letters,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.map((e) => LetterModel.fromJson(e)).toList();
        }
        return [];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب الخطابات',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<CreateLetterDataModel> getCreateData() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.lettersCreateData);

      if (response.statusCode == 200) {
        return CreateLetterDataModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب بيانات الإنشاء',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LetterModel> createLetter(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.letters, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LetterModel.fromJson(response.data['letter'] ?? response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل إنشاء الخطاب',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LetterModel> getLetter(int id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.letterById(id));

      if (response.statusCode == 200) {
        return LetterModel.fromJson(response.data['letter'] ?? response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب الخطاب',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LetterModel> updateLetter(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.letterById(id),
        data: data,
      );

      if (response.statusCode == 200) {
        return LetterModel.fromJson(response.data['letter'] ?? response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل تحديث الخطاب',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteLetter(int id) async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.letterById(id));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل حذف الخطاب',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LetterModel> issueLetter(int id) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.issueLetter(id));

      if (response.statusCode == 200) {
        return LetterModel.fromJson(response.data['letter'] ?? response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل إصدار الخطاب',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> getPdfUrl(int id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.letterPdfUrl(id));

      if (response.statusCode == 200) {
        return response.data['url'] ?? '';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب رابط PDF',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> getShareLink(int id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.letterShareLink(id));

      if (response.statusCode == 200) {
        return response.data['url'] ?? '';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل جلب رابط المشاركة',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> sendEmail(int id, String email) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendLetterEmail(id),
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'فشل إرسال البريد',
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
