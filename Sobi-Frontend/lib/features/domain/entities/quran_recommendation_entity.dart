class QuranRecommendationItemEntity {
  final int ayahId;
  final String ayahIdRaw;
  final String surahName;
  final int surah;
  final String indo;
  final String arab;

  QuranRecommendationItemEntity({
    required this.ayahId,
    required this.ayahIdRaw,
    required this.surahName,
    required this.surah,
    required this.indo,
    required this.arab,
  });
}

class QuranRecommendationEntity {
  final String question;
  final String summary;
  final List<QuranRecommendationItemEntity> results;

  QuranRecommendationEntity({
    required this.question,
    required this.summary,
    required this.results,
  });
}
