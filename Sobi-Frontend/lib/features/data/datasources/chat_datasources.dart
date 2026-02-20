import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat_models.dart';

class ChatDatasource {
  final Dio dio;
  final String baseUrl;

  ChatDatasource({Dio? dioClient, String? baseUrlOverride})
    : dio = dioClient ?? Dio(),
      baseUrl = baseUrlOverride ?? dotenv.env['BASE_URL'] ?? '';

  Future<RoomChatModel> createRoom({
    required String token,
    required String category,
    required bool visible,
    required String targetId,
  }) async {
    final res = await dio.post(
      '$baseUrl/chat/rooms',
      data: {'category': category, 'visible': visible, 'target_id': targetId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return RoomChatModel.fromJson(res.data);
  }

  Future<List<RoomChatModel>> getRooms({required String token}) async {
    final res = await dio.get(
      '$baseUrl/chat/rooms',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (res.data as List)
        .map((e) => RoomChatModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<RecentChatModel>> getRecentChats({required String token}) async {
    final res = await dio.get(
      '$baseUrl/chat/recent',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (res.data as List)
        .map((e) => RecentChatModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageChatModel>> getRoomMessages({
    required String token,
    required String roomId,
  }) async {
    print('[ChatDatasource] getRoomMessages: token=$token, roomId=$roomId');
    final res = await dio.get(
      '$baseUrl/chat/messages',
      queryParameters: {'room_id': roomId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print('[ChatDatasource] getRoomMessages response: ${res.data}');
    return (res.data as List)
        .map((e) => MessageChatModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MessageChatModel> postMessage({
    required String token,
    required String roomId,
    required String text,
  }) async {
    final res = await dio.post(
      '$baseUrl/chat/messages',
      data: {'room_id': roomId, 'text': text},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return MessageChatModel.fromJson(res.data);
  }

  Future<String> sendBotMessage({
    required String token,
    required String prompt,
  }) async {
    final res = await dio.post(
      '$baseUrl/chat/bot-message',
      data: {"prompt": prompt},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    // Debug response dari backend
    print('[ChatDatasource] sendBotMessage response: ${res.data}');
    if (res.data is Map<String, dynamic>) {
      res.data['is_bot'] = true;
      print('[ChatDatasource] Modified response (added is_bot): ${res.data}');
    }
    return res.data['reply'] ?? '';
  }
}
