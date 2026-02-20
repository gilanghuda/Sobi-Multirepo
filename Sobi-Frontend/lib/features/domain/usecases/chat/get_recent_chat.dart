import '../../entities/chat_entities.dart';
import '../../repositories/chat_repository.dart';

class GetRecentChat {
  final ChatRepository repository;
  GetRecentChat(this.repository);

  Future<List<RecentChatEntity>> call({required String token}) {
    return repository.getRecentChats(token: token);
  }
}
