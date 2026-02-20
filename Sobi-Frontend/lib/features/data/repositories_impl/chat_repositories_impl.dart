import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_datasources.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource datasource;
  ChatRepositoryImpl(this.datasource);

  @override
  Future<RoomChatEntity> createRoom({
    required String token,
    required String category,
    required bool visible,
    required String targetId,
  }) async {
    final model = await datasource.createRoom(
      token: token,
      category: category,
      visible: visible,
      targetId: targetId,
    );
    return model.toEntity();
  }

  @override
  Future<List<RoomChatEntity>> getRooms({required String token}) async {
    final models = await datasource.getRooms(token: token);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<RecentChatEntity>> getRecentChats({required String token}) async {
    final models = await datasource.getRecentChats(token: token);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<MessageChatEntity>> getRoomMessages({
    required String token,
    required String roomId,
  }) async {
    final models = await datasource.getRoomMessages(
      token: token,
      roomId: roomId,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<MessageChatEntity> postMessage({
    required String token,
    required String roomId,
    required String text,
  }) async {
    final model = await datasource.postMessage(
      token: token,
      roomId: roomId,
      text: text,
    );
    return model.toEntity();
  }

  @override
  Future<String> sendBotMessage({
    required String token,
    required String prompt,
  }) {
    return datasource.sendBotMessage(token: token, prompt: prompt);
  }
}
