import '../../domain/repositories/curhat_sobi_ws_repository.dart';
import '../datasources/curhat_sobi_ws_datasource.dart';

class CurhatSobiWsRepositoryImpl implements CurhatSobiWsRepository {
  final CurhatSobiWsDatasource datasource;
  CurhatSobiWsRepositoryImpl(this.datasource);

  @override
  void connectWS({
    required String token,
    required void Function(Map<String, dynamic> data) onEvent,
    void Function()? onDone,
    void Function(dynamic)? onError,
  }) {
    datasource.connectWS(
      token: token,
      onEvent: onEvent,
      onDone: onDone,
      onError: onError,
    );
  }

  @override
  void sendWS(Map<String, dynamic> data) {
    datasource.sendWS(data);
  }

  @override
  void closeWS() {
    datasource.closeWS();
  }

  @override
  Future<Map<String, dynamic>?> findMatch({
    required String token,
    required String role,
    required String category,
  }) {
    return datasource.findMatch(token: token, role: role, category: category);
  }
}
