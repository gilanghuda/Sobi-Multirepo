import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ahli_models.dart';

class AhliDatasource {
  final Dio dio;
  final String baseUrl;

  AhliDatasource({Dio? dioClient, String? baseUrlOverride})
    : dio = dioClient ?? Dio(),
      baseUrl = baseUrlOverride ?? dotenv.env['BASE_URL'] ?? '';

  Future<List<AhliModel>> getAhli() async {
    final res = await dio.get('$baseUrl/get-ahli');
    if (res.data != null && res.data is List) {
      return (res.data as List)
          .map((e) => AhliModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final res = await dio.get('$baseUrl/user/$id');
    if (res.data != null && res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    return null;
  }
}
