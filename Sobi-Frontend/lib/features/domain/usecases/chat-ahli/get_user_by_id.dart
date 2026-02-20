import '../../repositories/chat-ahli_repository.dart';

class GetUserById {
  final ChatAhliRepository repository;
  GetUserById(this.repository);

  Future<Map<String, dynamic>?> call(String id) {
    return repository.getUserById(id);
  }
}
