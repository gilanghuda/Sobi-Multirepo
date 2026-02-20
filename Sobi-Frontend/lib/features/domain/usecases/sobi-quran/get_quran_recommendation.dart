import '../../repositories/sobi-quran_repository.dart';
import '../../entities/quran_recommendation_entity.dart';

class GetQuranRecommendation {
  final SobiQuranRepository repository;
  GetQuranRecommendation(this.repository);

  Future<QuranRecommendationEntity?> call({required String question}) {
    return repository.getQuranRecommendation(question: question);
  }
}
