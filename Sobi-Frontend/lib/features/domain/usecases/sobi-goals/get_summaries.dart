import '../../repositories/sobi-goals_repository.dart';

class GetSummaries {
  final SobiGoalsRepository repository;
  GetSummaries(this.repository);

  // Future<void> call({required String userGoalId}) {
  //   return repository.getSummaries(userGoalId: userGoalId);
  // }

  Future<Map<String, dynamic>?> getSummaryData({required String userGoalId}) {
    return repository.getSummaryData(userGoalId);
  }
}
