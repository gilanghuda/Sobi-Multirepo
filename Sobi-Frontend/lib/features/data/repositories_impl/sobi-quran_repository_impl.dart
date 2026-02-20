import 'package:sobi/features/domain/entities/quran_recommendation_entity.dart';
import 'package:sobi/features/domain/entities/surat_detail_entity.dart';
import 'package:sobi/features/domain/entities/tafsir_entity.dart';

import '../../domain/repositories/sobi-quran_repository.dart';
import '../../domain/entities/surat_entity.dart';
import '../datasources/sobi-quran_datasources.dart';
import '../models/surat_detail_model.dart';
import '../models/tafsir_model.dart';

class SobiQuranRepositoryImpl implements SobiQuranRepository {
  final SobiQuranDatasource datasource;
  SobiQuranRepositoryImpl(this.datasource);

  @override
  Future<List<SuratEntity>> getSurat() async {
    final models = await datasource.getSurat();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<SuratDetailEntity?> getSuratDetail(int nomor) async {
    final model = await datasource.getSuratDetail(nomor);
    return model?.toEntity();
  }

  @override
  Future<AyahTafsirEntity?> getAyahTafsir({
    required int surah,
    required int ayah,
  }) async {
    final model = await datasource.getAyahTafsir(surah: surah, ayah: ayah);
    return model?.toEntity();
  }

  @override
  Future<QuranRecommendationEntity?> getQuranRecommendation({
    required String question,
  }) async {
    final model = await datasource.getQuranRecommendation(question: question);
    return model?.toEntity();
  }
}
