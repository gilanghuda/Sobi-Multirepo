import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sobi/features/data/models/sobi_goals_models.dart';
import 'package:sobi/features/data/models/summary-goals_model.dart';
import 'dart:convert';
import '../../domain/entities/sobi-goals.dart';
import '../../domain/usecases/sobi-goals/create_goals.dart';
import '../../domain/usecases/sobi-goals/get_mission.dart';
import '../../domain/usecases/sobi-goals/post_task_user.dart';
import '../../domain/usecases/sobi-goals/get_summaries.dart';
import '../../domain/usecases/sobi-goals/post_summaries.dart';
import '../../data/datasources/sobi-goals_datasources.dart';

class SobiGoalsProvider extends ChangeNotifier {
  final CreateGoals createGoalsUsecase;
  final GetTodayMission getTodayMissionUsecase;
  final CompleteTask completeTaskUsecase;
  final GetSummaries getSummariesUsecase;
  final PostSummaries postSummariesUsecase;
  final SobiGoalsDatasource datasource;

  List<TodayMissionEntity> todayMissions = [];
  List<PreviousDayEntity> previousDays = []; // konsisten pakai Entity
  String? goalStatus;
  UserGoalEntity? goalEntity;
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? summaryData;

  SobiGoalsProvider({
    required this.createGoalsUsecase,
    required this.getTodayMissionUsecase,
    required this.completeTaskUsecase,
    required this.getSummariesUsecase,
    required this.postSummariesUsecase,
    required this.datasource,
  });

  Future<void> createGoal(String goalCategory, String targetEndDate) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final goal = await createGoalsUsecase(
        goalCategory: goalCategory,
        targetEndDate: targetEndDate,
      );
      goalEntity = goal;
      goalStatus = goal?.status;
      await fetchTodayMission(date: '');
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchGoalStatusAndMission() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      goalStatus =
          await getTodayMissionUsecase.repository.getCachedGoalStatus();
      goalEntity = await getTodayMissionUsecase.repository.getCachedGoal();
      await fetchTodayMission(date: '');
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTodayMission({required String date}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final missions = await getTodayMissionUsecase(date: date);
      todayMissions = missions;
      // Ambil previousDays dari data pertama jika ada, pakai Entity
      previousDays = missions.isNotEmpty ? missions.first.previousDays : [];
      print('[provider] fetchTodayMission previousDays: $previousDays');
      if (todayMissions.isNotEmpty) {
        final active = todayMissions.firstWhere(
          (m) => m.userGoal.status != null,
          orElse: () => todayMissions.first,
        );
        goalStatus = active.userGoal.status;
        print('[provider] fetchTodayMission goalStatus: $goalStatus');
        if (goalStatus == 'active') {
          await datasource.storage.write(key: 'goal_status', value: 'active');
        }
      }
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> completeTask(String userGoalId, String taskId) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await completeTaskUsecase(
        userGoalId: userGoalId,
        taskId: taskId,
        completed: true,
      );
      await fetchTodayMission(date: ''); // reload mission after complete
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  // Future<void> getSummaries(String userGoalId) async {
  //   isLoading = true;
  //   error = null;
  //   notifyListeners();
  //   try {
  //     await getSummariesUsecase(userGoalId: userGoalId);
  //     error = null;
  //   } catch (e) {
  //     error = e.toString();
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<SummaryGoalsEntity?> fetchSummaryData(String userGoalId) async {
    try {
      final data = await getSummariesUsecase.getSummaryData(
        userGoalId: userGoalId,
      );
      debugPrint('[provider] fetchSummaryData raw: $data');
      if (data != null) {
        // Jika data adalah List, ambil objek pertama
        final summaryJson = (data is List && data.isNotEmpty) ? data[0] : data;
        debugPrint('[provider] fetchSummaryData parsed: $summaryJson');
        // Simpan ke cache
        await datasource.storage.write(
          key: 'summary_data',
          value: jsonEncode(summaryJson),
        );
        // Hapus goal dari cache
        await datasource.storage.delete(key: 'goal_data');
        await datasource.storage.delete(key: 'goal_status');
        // Convert ke entity
        final summaryModel = SummaryGoalsModel.fromJson(summaryJson);
        summaryData = summaryJson;
        return summaryModel.toEntity();
      }
      return null;
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  Future<void> postSummary({
    required String userGoalId,
    required List<String> reflection, // ubah ke List<String>
    required List<String> selfChanges,
  }) async {
    try {
      debugPrint(
        '[PROVIDER] postSummariesUsecase: userGoalId=$userGoalId, reflection=$reflection, selfChanges=$selfChanges',
      );
      await postSummariesUsecase(
        userGoalId: userGoalId,
        reflection: reflection,
        selfChanges: selfChanges,
      );
      debugPrint('[PROVIDER] postSummariesUsecase success');
    } catch (e) {
      error = e.toString();
      debugPrint('[PROVIDER] postSummariesUsecase error: $error');
    }
  }
}
  
