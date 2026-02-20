abstract class CurhatSobiWsRepository {
  void connectWS({
    required String token,
    required void Function(Map<String, dynamic> data) onEvent,
    void Function()? onDone,
    void Function(dynamic)? onError,
  });

  void sendWS(Map<String, dynamic> data);

  void closeWS();

  Future<Map<String, dynamic>?> findMatch({
    required String token,
    required String role,
    required String category,
  });
}
