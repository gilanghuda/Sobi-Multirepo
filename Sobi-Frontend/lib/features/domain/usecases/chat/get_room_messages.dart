import '../../entities/chat_entities.dart';
import '../../repositories/chat_repository.dart';

class GetRoomMessages {
  final ChatRepository repository;
  GetRoomMessages(this.repository);

  Future<List<MessageChatEntity>> call({
    required String token,
    required String roomId,
  }) {
    return repository.getRoomMessages(token: token, roomId: roomId);
  }
}
