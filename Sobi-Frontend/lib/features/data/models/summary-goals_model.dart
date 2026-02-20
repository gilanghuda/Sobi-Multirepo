import 'package:sobi/features/domain/entities/sobi-goals.dart';

class SummaryGoalsModel {
  final String id;
  final String userGoalId;
  final String userId;
  final String goalCategory;
  final int completionPercentage;
  final int daysCompleted;
  final int missionsCompleted;
  final int tasksCompleted;
  final int totalDays;
  final int totalMissions;
  final int totalTasks;
  final String reflection; // ubah dari List<String> ke String
  final List<String> selfChanges;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  SummaryGoalsModel({
    required this.id,
    required this.userGoalId,
    required this.userId,
    required this.goalCategory,
    required this.completionPercentage,
    required this.daysCompleted,
    required this.missionsCompleted,
    required this.tasksCompleted,
    required this.totalDays,
    required this.totalMissions,
    required this.totalTasks,
    required this.reflection,
    required this.selfChanges,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory SummaryGoalsModel.fromJson(Map<String, dynamic> json) {
    // Pastikan semua int field di-cast dari double jika perlu
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }
    return SummaryGoalsModel(
      id: json['id'],
      userGoalId: json['user_goal_id'],
      userId: json['user_id'],
      goalCategory: json['goal_category'],
      completionPercentage: toInt(json['completion_percentage']),
      daysCompleted: toInt(json['days_completed']),
      missionsCompleted: toInt(json['missions_completed']),
      tasksCompleted: toInt(json['tasks_completed']),
      totalDays: toInt(json['total_days']),
      totalMissions: toInt(json['total_missions']),
      totalTasks: toInt(json['total_tasks']),
      reflection: json['reflection']?.toString() ?? '',
      selfChanges:
          (json['self_changes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_goal_id': userGoalId,
      'user_id': userId,
      'goal_category': goalCategory,
      'completion_percentage': completionPercentage,
      'days_completed': daysCompleted,
      'missions_completed': missionsCompleted,
      'tasks_completed': tasksCompleted,
      'total_days': totalDays,
      'total_missions': totalMissions,
      'total_tasks': totalTasks,
      'reflection': reflection,
      'self_changes': selfChanges,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  SummaryGoalsEntity toEntity() {
    return SummaryGoalsEntity(
      id: id,
      userGoalId: userGoalId,
      userId: userId,
      goalCategory: goalCategory,
      completionPercentage: completionPercentage,
      daysCompleted: daysCompleted,
      missionsCompleted: missionsCompleted,
      tasksCompleted: tasksCompleted,
      totalDays: totalDays,
      totalMissions: totalMissions,
      totalTasks: totalTasks,
      reflection: reflection,
      selfChanges: selfChanges,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
    );
  }
}
