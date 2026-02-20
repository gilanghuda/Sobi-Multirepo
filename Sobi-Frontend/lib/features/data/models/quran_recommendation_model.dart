import '../../domain/entities/quran_recommendation_entity.dart';

class QuranRecommendationItemModel {
  final int ayahId;
  final String ayahIdRaw;
  final String surahName;
  final int surah;
  final String indo;
  final String arab;

  QuranRecommendationItemModel({
    required this.ayahId,
    required this.ayahIdRaw,
    required this.surahName,
    required this.surah,
    required this.indo,
    required this.arab,
  });

  factory QuranRecommendationItemModel.fromJson(Map<String, dynamic> json) {
    final ayahIdRaw = json['ayah_id'] ?? '';
    final ayahId = int.tryParse(ayahIdRaw.split(':').last) ?? 0;
    return QuranRecommendationItemModel(
      ayahId: ayahId,
      ayahIdRaw: ayahIdRaw,
      surahName: json['surah_name'] ?? '',
      surah: json['surah'] ?? 0,
      indo: json['indo'] ?? '',
      arab: json['arab'] ?? '',
    );
  }

  QuranRecommendationItemEntity toEntity() {
    return QuranRecommendationItemEntity(
      ayahId: ayahId,
      ayahIdRaw: ayahIdRaw,
      surahName: surahName,
      surah: surah,
      indo: indo,
      arab: arab,
    );
  }
}

class QuranRecommendationModel {
  final String question;
  final String summary;
  final List<QuranRecommendationItemModel> results;

  QuranRecommendationModel({
    required this.question,
    required this.summary,
    required this.results,
  });

  factory QuranRecommendationModel.fromJson(Map<String, dynamic> json) {
    return QuranRecommendationModel(
      question: json['question'] ?? '',
      summary: json['summary'] ?? '',
      results:
          (json['results'] as List)
              .map((e) => QuranRecommendationItemModel.fromJson(e))
              .toList(),
    );
  }

  QuranRecommendationEntity toEntity() {
    return QuranRecommendationEntity(
      question: question,
      summary: summary,
      results: results.map((e) => e.toEntity()).toList(),
    );
  }
}
