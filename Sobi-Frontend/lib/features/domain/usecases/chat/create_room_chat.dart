import '../../entities/chat_entities.dart';
import '../../repositories/chat_repository.dart';

class CreateRoomChat {
  final ChatRepository repository;
  CreateRoomChat(this.repository);

  Future<RoomChatEntity> call({
    required String token,
    required String category,
    required bool visible,
    required String targetId,
  }) {
    return repository.createRoom(
      token: token,
      category: category,
      visible: visible,
      targetId: targetId,
    );
  }
}
