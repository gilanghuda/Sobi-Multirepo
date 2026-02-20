import '../../repositories/curhat_sobi_ws_repository.dart';

class ConnectCurhatSobiWS {
  final CurhatSobiWsRepository repository;
  ConnectCurhatSobiWS(this.repository);

  void call({
    required String token,
    required void Function(Map<String, dynamic> data) onEvent,
    void Function()? onDone,
    void Function(dynamic)? onError,
  }) {
    repository.connectWS(
      token: token,
      onEvent: onEvent,
      onDone: onDone,
      onError: onError,
    );
  }
}
