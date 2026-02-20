import '../../domain/repositories/sobi-goals_repository.dart';
import '../../domain/entities/sobi-goals.dart';
import '../datasources/sobi-goals_datasources.dart';
import '../models/sobi_goals_models.dart';

class SobiGoalsRepositoryImpl implements SobiGoalsRepository {
  final SobiGoalsDatasource datasource;
  SobiGoalsRepositoryImpl(this.datasource);

  @override
  Future<UserGoalEntity?> createGoal({
    required String goalCategory,
    required String targetEndDate,
  }) async {
    final model = await datasource.createGoal(
      goalCategory: goalCategory,
      targetEndDate: targetEndDate,
    );
    return model?.toEntity();
  }

  @override
  Future<List<TodayMissionEntity>> getTodayMission({
    required String date,
  }) async {
    final List<TodayMissionModel> result = await datasource.getTodayMission(
      date: date,
    );
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> completeTask({
    required String userGoalId,
    required String taskId,
    required bool completed,
  }) {
    return datasource.completeTask(
      userGoalId: userGoalId,
      taskId: taskId,
      completed: completed,
    );
  }

 

  @override
  Future<String?> getCachedGoalStatus() {
    return datasource.getCachedGoalStatus();
  }

  @override
  Future<UserGoalEntity?> getCachedGoal() async {
    final model = await datasource.getCachedGoal();
    return model?.toEntity();
  }

  @override
  Future<Map<String, dynamic>?> getSummaryData(String userGoalId) async {
    return await datasource.getSummary(userGoalId: userGoalId);
  }

  @override
  Future<void> postSummary({
    required String userGoalId,
    required List<String> reflection, // ubah ke List<String>
    required List<String> selfChanges,
  }) {
    return datasource.postSummary(
      userGoalId: userGoalId,
      reflection: reflection,
      selfChanges: selfChanges,
    );
  }
}
