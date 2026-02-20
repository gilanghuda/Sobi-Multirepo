import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/education_model.dart';

class EducationDatasource {
  final Dio dio;
  final String baseUrl;
  final FlutterSecureStorage storage;

  EducationDatasource({
    Dio? dioClient,
    String? baseUrlOverride,
    FlutterSecureStorage? secureStorage,
  }) : dio = dioClient ?? Dio(),
       baseUrl = baseUrlOverride ?? dotenv.env['BASE_URL'] ?? '',
       storage = secureStorage ?? const FlutterSecureStorage();

  Future<List<EducationModel>> getEducations() async {
    print('[DATASOURCE] getEducations request: $baseUrl/educations');
    final res = await dio.get('$baseUrl/educations');
    print('[DATASOURCE] getEducations response: ${res.data}');
    if (res.data is List) {
      return (res.data as List).map((e) => EducationModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<EducationModel?> getEducationDetail(String id) async {
    final token = await storage.read(key: 'auth_token');
    print(
      '[DATASOURCE] getEducationDetail request: $baseUrl/educations/$id token=$token',
    );
    final res = await dio.get(
      '$baseUrl/educations/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print('[DATASOURCE] getEducationDetail response: ${res.data}');
    if (res.data != null) {
      return EducationModel.fromJson(res.data);
    }
    return null;
  }

  Future<List<EducationModel>> getEducationHistory() async {
    final token = await storage.read(key: 'auth_token');
    print(
      '[DATASOURCE] getEducationHistory request: $baseUrl/educations/history token=$token',
    );
    final res = await dio.get(
      '$baseUrl/educations/history',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print('[DATASOURCE] getEducationHistory response: ${res.data}');
    if (res.data is List) {
      for (var i = 0; i < (res.data as List).length; i++) {
        print('[DATASOURCE] history item[$i]: ${(res.data as List)[i]}');
      }
      return (res.data as List).map((e) => EducationModel.fromJson(e)).toList();
    }
    return [];
  }
}
