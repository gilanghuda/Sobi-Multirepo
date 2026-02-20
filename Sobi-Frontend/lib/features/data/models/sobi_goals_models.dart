import 'package:sobi/features/domain/entities/sobi-goals.dart';

// UserGoalModel
class UserGoalModel {
  final String id;
  final String userId;
  final String goalCategory;
  final String status;
  final int currentDay;
  final DateTime startDate;
  final DateTime targetEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserGoalModel({
    required this.id,
    required this.userId,
    required this.goalCategory,
    required this.status,
    required this.currentDay,
    required this.startDate,
    required this.targetEndDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserGoalModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return UserGoalModel(
      id: json['id'],
      userId: json['user_id'],
      goalCategory: json['goal_category'],
      status: json['status'],
      currentDay: toInt(json['current_day']),
      startDate: DateTime.parse(json['start_date']),
      targetEndDate: DateTime.parse(json['target_end_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  UserGoalEntity toEntity() {
    return UserGoalEntity(
      id: id,
      userId: userId,
      goalCategory: goalCategory,
      status: status,
      currentDay: currentDay,
      startDate: startDate,
      targetEndDate: targetEndDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// MissionModel
class MissionModel {
  final String id;
  final int dayNumber;
  final String focus;
  final String category;

  MissionModel({
    required this.id,
    required this.dayNumber,
    required this.focus,
    required this.category,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return MissionModel(
      id: json['id'],
      dayNumber: toInt(json['day_number']),
      focus: json['focus'],
      category: json['category'],
    );
  }

  MissionEntity toEntity() {
    return MissionEntity(
      id: id,
      dayNumber: dayNumber,
      focus: focus,
      category: category,
    );
  }
}

// TaskModel
class TaskModel {
  final String id;
  final String missionId;
  final String text;

  TaskModel({required this.id, required this.missionId, required this.text});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      missionId: json['mission_id'],
      text: json['text'],
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(id: id, missionId: missionId, text: text);
  }
}

// ProgressModel
class ProgressModel {
  final String id;
  final String userGoalId;
  final String? missionId;
  final String? taskId;
  final String userId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int? totalTasks;
  final int? completedTasks;
  final double? completionPercentage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProgressModel({
    required this.id,
    required this.userGoalId,
    this.missionId,
    this.taskId,
    required this.userId,
    required this.isCompleted,
    this.completedAt,
    this.totalTasks,
    this.completedTasks,
    this.completionPercentage,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return ProgressModel(
      id: json['id'],
      userGoalId: json['user_goal_id'],
      missionId: json['mission_id'],
      taskId: json['task_id'],
      userId: json['user_id'],
      isCompleted: json['is_completed'],
      completedAt:
          json['completed_at'] != null
              ? DateTime.tryParse(json['completed_at'])
              : null,
      totalTasks: toInt(json['total_tasks']),
      completedTasks: toInt(json['completed_tasks']),
      completionPercentage: toDouble(json['completion_percentage']),
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  ProgressEntity toEntity() {
    return ProgressEntity(
      id: id,
      userGoalId: userGoalId,
      missionId: missionId,
      taskId: taskId,
      userId: userId,
      isCompleted: isCompleted,
      completedAt: completedAt,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      completionPercentage: completionPercentage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// TaskWithProgressModel
class TaskWithProgressModel {
  final TaskModel task;
  final ProgressModel progress;

  TaskWithProgressModel({required this.task, required this.progress});

  factory TaskWithProgressModel.fromJson(Map<String, dynamic> json) {
    return TaskWithProgressModel(
      task: TaskModel.fromJson(json['task']),
      progress: ProgressModel.fromJson(json['progress']),
    );
  }

  TaskWithProgressEntity toEntity() {
    return TaskWithProgressEntity(
      task: task.toEntity(),
      progress: progress.toEntity(),
    );
  }
}

// MissionWithTasksModel
class MissionWithTasksModel {
  final MissionModel mission;
  final List<TaskWithProgressModel> tasks;
  final ProgressModel progress;

  MissionWithTasksModel({
    required this.mission,
    required this.tasks,
    required this.progress,
  });

  factory MissionWithTasksModel.fromJson(Map<String, dynamic> json) {
    return MissionWithTasksModel(
      mission: MissionModel.fromJson(json['mission']),
      tasks:
          (json['tasks'] is List && json['tasks'] != null)
              ? (json['tasks'] as List)
                  .map((e) => TaskWithProgressModel.fromJson(e))
                  .toList()
              : <TaskWithProgressModel>[],
      progress: ProgressModel.fromJson(json['progress']),
    );
  }

  MissionWithTasksEntity toEntity() {
    return MissionWithTasksEntity(
      mission: mission.toEntity(),
      tasks: tasks.map((t) => t.toEntity()).toList(),
      progress: progress.toEntity(),
    );
  }
}

// PreviousDayModel
class PreviousDayModel {
  final int dayIndex;
  final bool isCompleted;

  PreviousDayModel({required this.dayIndex, required this.isCompleted});

  factory PreviousDayModel.fromJson(Map<String, dynamic> json) {
    return PreviousDayModel(
      dayIndex: json['day_index'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
    );
  }
}

// TodayMissionModel
class TodayMissionModel {
  final UserGoalModel userGoal;
  final int dayIndex;
  final List<MissionWithTasksModel> missions;
  final List<PreviousDayModel> previousDays;

  TodayMissionModel({
    required this.userGoal,
    required this.dayIndex,
    required this.missions,
    required this.previousDays,
  });

  factory TodayMissionModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return TodayMissionModel(
      userGoal: UserGoalModel.fromJson(json['user_goal']),
      dayIndex: toInt(json['day_index']),
      missions:
          (json['missions'] is List && json['missions'] != null)
              ? (json['missions'] as List)
                  .map((e) => MissionWithTasksModel.fromJson(e))
                  .toList()
              : <MissionWithTasksModel>[],
      previousDays:
          (json['previous_days'] is List && json['previous_days'] != null)
              ? (json['previous_days'] as List)
                  .map((e) => PreviousDayModel.fromJson(e))
                  .toList()
              : <PreviousDayModel>[],
    );
  }
}

// Extension untuk konversi Model → Entity
extension TodayMissionModelX on TodayMissionModel {
  TodayMissionEntity toEntity() {
    return TodayMissionEntity(
      userGoal: userGoal.toEntity(),
      dayIndex: dayIndex,
      missions: missions.map((m) => m.toEntity()).toList(),
      previousDays:
          previousDays
              .map(
                (p) => PreviousDayEntity(
                  dayIndex: p.dayIndex,
                  isCompleted: p.isCompleted,
                ),
              )
              .toList(),
    );
  }
}
