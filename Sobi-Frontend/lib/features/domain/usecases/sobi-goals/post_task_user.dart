import '../../repositories/sobi-goals_repository.dart';

class CompleteTask {
  final SobiGoalsRepository repository;
  CompleteTask(this.repository);

  Future<void> call({
    required String userGoalId,
    required String taskId,
    required bool completed,
  }) {
    return repository.completeTask(
      userGoalId: userGoalId,
      taskId: taskId,
      completed: completed,
    );
  }
}
