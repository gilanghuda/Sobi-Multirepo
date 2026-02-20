import '../../repositories/sobi-goals_repository.dart';
import '../../entities/sobi-goals.dart';

class CreateGoals {
  final SobiGoalsRepository repository;
  CreateGoals(this.repository);

  Future<UserGoalEntity?> call({
    required String goalCategory,
    required String targetEndDate,
  }) {
    return repository.createGoal(
      goalCategory: goalCategory,
      targetEndDate: targetEndDate,
    );
  }
}
