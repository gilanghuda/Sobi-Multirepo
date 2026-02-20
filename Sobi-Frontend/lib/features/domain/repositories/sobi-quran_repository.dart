import '../entities/surat_entity.dart';
import '../entities/surat_detail_entity.dart';
import '../entities/tafsir_entity.dart';
import '../entities/quran_recommendation_entity.dart';

abstract class SobiQuranRepository {
  Future<List<SuratEntity>> getSurat();
  Future<SuratDetailEntity?> getSuratDetail(int nomor);
  Future<AyahTafsirEntity?> getAyahTafsir({
    required int surah,
    required int ayah,
  });
  Future<QuranRecommendationEntity?> getQuranRecommendation({
    required String question,
  });
}
