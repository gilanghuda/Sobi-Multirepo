import '../../entities/chat_entities.dart';
import '../../repositories/chat_repository.dart';

class PostMessageChat {
  final ChatRepository repository;
  PostMessageChat(this.repository);

  Future<MessageChatEntity> call({
    required String token,
    required String roomId,
    required String text,
  }) {
    return repository.postMessage(token: token, roomId: roomId, text: text);
  }
}
