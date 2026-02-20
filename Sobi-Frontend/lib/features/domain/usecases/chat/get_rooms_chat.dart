import '../../entities/chat_entities.dart';
import '../../repositories/chat_repository.dart';

class GetRoomsChat {
  final ChatRepository repository;
  GetRoomsChat(this.repository);

  Future<List<RoomChatEntity>> call({required String token}) {
    return repository.getRooms(token: token);
  }
}
