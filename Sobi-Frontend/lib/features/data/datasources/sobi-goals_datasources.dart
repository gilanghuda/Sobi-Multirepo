import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../models/sobi_goals_models.dart';

class SobiGoalsDatasource {
  final Dio dio;
  final FlutterSecureStorage storage; // pastikan ini public
  final String baseUrl;

  SobiGoalsDatasource({
    Dio? dioClient,
    FlutterSecureStorage? secureStorage,
    String? baseUrlOverride,
  }) : dio = dioClient ?? Dio(),
       storage = secureStorage ?? const FlutterSecureStorage(),
       baseUrl = baseUrlOverride ?? dotenv.env['BASE_URL'] ?? '' {
    // BYPASS SSL UNTUK DEVELOPMENT/TESTING
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (
      HttpClient client,
    ) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<UserGoalModel?> createGoal({
    required String goalCategory,
    required String targetEndDate,
  }) async {
    try {
      final token = await _getToken();
      final now = DateTime.now();
      final startDate = DateFormat('yyyy-MM-dd').format(now);
      print('[DEBUG getToken] token=$token');
      print(
        '[DEBUG getToken] "goal_category": $goalCategory, "start_date": $startDate, "target_end_date": $targetEndDate',
      );
      final res = await dio.post(
        '$baseUrl/goals/create',
        data: {
          "goal_category": goalCategory,
          "start_date": startDate,
          "target_end_date": targetEndDate,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = res.data;
      if (data != null && data['goal'] != null) {
        // Simpan status goal ke cache
        await storage.write(key: 'goal_status', value: data['goal']['status']);
        await storage.write(key: 'goal_data', value: jsonEncode(data['goal']));
        return UserGoalModel.fromJson(data['goal']); // return Model
      }
      return null;
    } catch (e, stack) {
      // Bisa diganti dengan log atau throw sesuai kebutuhan
      print('Error saat createGoal: $e');
      print(stack);
      return null;
    }
  }

  Future<String?> getCachedGoalStatus() async {
    return await storage.read(key: 'goal_status');
  }

  Future<UserGoalModel?> getCachedGoal() async {
    final goalJson = await storage.read(key: 'goal_data');
    if (goalJson != null) {
      return UserGoalModel.fromJson(jsonDecode(goalJson)); // return Model
    }
    return null;
  }

  Future<List<TodayMissionModel>> getTodayMission({
    required String date,
  }) async {
    final token = await _getToken();
    // Overwrite date dengan hari ini
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    print('[DEBUG getTodayMission] date (overwritten)=$today');
    final res = await dio.get(
      '$baseUrl/goals/mission?date=$today',
      queryParameters: {'date': today},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print('[Debug getTodayMission] raw banget response=$res');
    print('[DEBUG getTodayMission] response=${res.data}');
    final raw = res.data;
    print('[DEBUG getTodayMission] response=$raw');
    if (raw is List) {
      return raw.map((e) => TodayMissionModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> completeTask({
    required String userGoalId,
    required String taskId,
    required bool completed,
  }) async {
    final token = await _getToken();
    print('[DEBUG completeTask] token=$token');
    print(
      '[DEBUG completeTask] user_goal_id=$userGoalId, task_id=$taskId, completed=$completed',
    );
    await dio.post(
      '$baseUrl/goals/tasks/complete',
      data: {
        "user_goal_id": userGoalId,
        "task_id": taskId,
        "completed": completed,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }


  Future<Map<String, dynamic>?> getSummary({required String userGoalId}) async {
    final token = await _getToken();
    final res = await dio.get(
      '$baseUrl/goals/summaries',
      data: {"user_goal_id": userGoalId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print('[datasource] getSummary response: ${res.data}');
    if (res.data is List && (res.data as List).isNotEmpty) {
      return (res.data as List).first as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> postSummary({
    required String userGoalId,
    required List<String> reflection, // ubah ke List<String>
    required List<String> selfChanges,
  }) async {
    final token = await _getToken();
    final payload = {
      "user_goal_id": userGoalId,
      "reflection": reflection,
      "self_changes": selfChanges,
    };
    print('[DATASOURCE] postSummary payload: $payload');
    final res = await dio.post(
      '$baseUrl/goals/summaries',
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print('[DATASOURCE] postSummary response: ${res.data}');
  }
}
