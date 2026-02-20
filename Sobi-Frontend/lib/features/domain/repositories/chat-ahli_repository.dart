import '../entities/ahli_entity.dart';

abstract class ChatAhliRepository {
  Future<List<AhliEntity>> getAhli();
  Future<Map<String, dynamic>?> getUserById(String id);
}
