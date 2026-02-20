import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class CurhatSobiWsDatasource {
  WebSocketChannel? channel;

  void connectWS({
    required String token,
    required void Function(Map<String, dynamic> data) onEvent,
    void Function()? onDone,
    void Function(dynamic)? onError,
  }) {
    final url = "wss://backend.sobatbimbing.com/chat/ws?token=$token";
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel!.stream.listen(
      (event) {
        final data = jsonDecode(event);
        onEvent(data);
      },
      onDone: onDone,
      onError: onError,
    );
  }

  void sendWS(Map<String, dynamic> data) {
    channel?.sink.add(jsonEncode(data));
  }

  void closeWS() {
    channel?.sink.close();
  }

  Future<Map<String, dynamic>?> findMatch({
    required String token,
    required String role,
    required String category,
  }) async {
    final res = await http.post(
      Uri.parse("https://backend.sobatbimbing.com/chat/matchmaking"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'role': role, 'category': category}),
    );
    print("[CurhatSobiWsDatasource] findMatch response: ${res.body}");
    try {
      final data = res.body.isNotEmpty ? jsonDecode(res.body) : null;
      if (data is Map<String, dynamic>) return data;
    } catch (_) {}
    return null;
  }
}
