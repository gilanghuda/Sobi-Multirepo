import '../../domain/entities/ahli_entity.dart';
import '../../domain/repositories/chat-ahli_repository.dart';
import '../datasources/ahli_datasources.dart';

class ChatAhliRepositoryImpl implements ChatAhliRepository {
  final AhliDatasource datasource;
  ChatAhliRepositoryImpl(this.datasource);

  @override
  Future<List<AhliEntity>> getAhli() async {
    final models = await datasource.getAhli();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>?> getUserById(String id) {
    return datasource.getUserById(id);
  }
}
