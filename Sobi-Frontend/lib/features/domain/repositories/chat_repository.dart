import '../entities/chat_entities.dart';

abstract class ChatRepository {
  Future<RoomChatEntity> createRoom({
    required String token,
    required String category,
    required bool visible,
    required String targetId,
  });

  Future<List<RoomChatEntity>> getRooms({required String token});

  Future<List<RecentChatEntity>> getRecentChats({required String token});

  Future<List<MessageChatEntity>> getRoomMessages({
    required String token,
    required String roomId,
  });

  Future<MessageChatEntity> postMessage({
    required String token,
    required String roomId,
    required String text,
  });

  Future<String> sendBotMessage({
    required String token,
    required String prompt,
  });
}
