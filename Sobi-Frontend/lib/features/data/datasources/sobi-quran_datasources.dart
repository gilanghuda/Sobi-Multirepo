import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/surat_model.dart';
import '../models/surat_detail_model.dart';
import '../models/tafsir_model.dart';
import '../models/quran_recommendation_model.dart';

class SobiQuranDatasource {
  final Dio dio;
  final String baseUrl;

  SobiQuranDatasource({Dio? dioClient, String? baseUrlOverride})
    : dio = dioClient ?? Dio(),
      baseUrl = baseUrlOverride ?? 'https://equran.id/api/v2';

  Future<List<SuratModel>> getSurat() async {
    final res = await dio.get('$baseUrl/surat');
    if (res.data != null && res.data['data'] is List) {
      return (res.data['data'] as List)
          .map((e) => SuratModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<SuratDetailModel?> getSuratDetail(int nomor) async {
    print('[DATASOURCE] getSuratDetail request: $baseUrl/surat/$nomor');
    final res = await dio.get('$baseUrl/surat/$nomor');
    print('[DATASOURCE] getSuratDetail response: ${res.data}');
    if (res.data != null && res.data['data'] != null) {
      return SuratDetailModel.fromJson(res.data);
    }
    return null;
  }

  // Fungsi baru untuk endpoint tafsir ayat per range
  Future<AyahTafsirModel?> getAyahTafsir({
    required int surah,
    required int ayah,
  }) async {
    final base = dotenv.env['BASE_URL'] ?? baseUrl;
    final url = '$base/rag/detail?surah=$surah&ayah=$ayah';
    final res = await dio.get(url);
    if (res.data != null && res.data is Map<String, dynamic>) {
      return AyahTafsirModel.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<QuranRecommendationModel?> getQuranRecommendation({
    required String question,
  }) async {
    final base = dotenv.env['BASE_URL'] ?? baseUrl;
    final url = '$base/rag/qa?q=$question';
    final res = await dio.get(url);
    if (res.data != null && res.data is Map<String, dynamic>) {
      return QuranRecommendationModel.fromJson(
        res.data as Map<String, dynamic>,
      );
    }
    return null;
  }
}
