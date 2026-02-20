import '../../entities/ahli_entity.dart';
import '../../repositories/chat-ahli_repository.dart';

class GetAhli {
  final ChatAhliRepository repository;
  GetAhli(this.repository);

  Future<List<AhliEntity>> call() {
    return repository.getAhli();
  }
}
