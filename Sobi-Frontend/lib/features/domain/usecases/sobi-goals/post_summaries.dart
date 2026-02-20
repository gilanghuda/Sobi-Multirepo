import '../../repositories/sobi-goals_repository.dart';

class PostSummaries {
  final SobiGoalsRepository repository;
  PostSummaries(this.repository);

  Future<void> call({
    required String userGoalId,
    required List<String> reflection, // ubah ke List<String>
    required List<String> selfChanges,
  }) {
    return repository.postSummary(
      userGoalId: userGoalId,
      reflection: reflection,
      selfChanges: selfChanges,
    );
  }
}
