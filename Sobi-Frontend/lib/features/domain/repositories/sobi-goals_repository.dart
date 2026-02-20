import 'package:sobi/features/data/models/sobi_goals_models.dart';
import 'package:sobi/features/domain/repositories/sobi-goals_repository.dart'
    as datasource;

import '../entities/sobi-goals.dart';

abstract class SobiGoalsRepository {
  Future<UserGoalEntity?> createGoal({
    required String goalCategory,
    required String targetEndDate,
  });
  Future<List<TodayMissionEntity>> getTodayMission({required String date});
  Future<void> completeTask({
    required String userGoalId,
    required String taskId,
    required bool completed,
  });
  // Future<void> getSummaries({required String userGoalId});
  Future<String?> getCachedGoalStatus();
  Future<UserGoalEntity?> getCachedGoal();
  Future<Map<String, dynamic>?> getSummaryData(String userGoalId);
  Future<void> postSummary({
    required String userGoalId,
    required List<String> reflection, // ubah ke List<String>
    required List<String> selfChanges,
  });
}
