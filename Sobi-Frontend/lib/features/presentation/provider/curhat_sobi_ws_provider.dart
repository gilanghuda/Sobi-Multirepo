import 'package:flutter/material.dart';
import 'package:sobi/features/data/datasources/auth_datasources.dart';
import 'package:go_router/go_router.dart';
import '../../domain/usecases/curhat_sobi/connect_ws.dart';
import '../../domain/usecases/curhat_sobi/find_match.dart';

enum CurhatChatState { idle, searching, matched, chatting }

class CurhatSobiWsProvider extends ChangeNotifier {
  CurhatChatState state = CurhatChatState.idle;
  String? roomId;
  String? partner;
  List<Map<String, dynamic>> messages = [];
  final String token;

  final ConnectCurhatSobiWS connectWsUsecase;
  final FindCurhatSobiMatch findMatchUsecase;

  bool _wsConnected = false;
  BuildContext? _context; // simpan context untuk navigasi otomatis
  bool _findMatchActive = false;

  CurhatSobiWsProvider({
    required this.token,
    required this.connectWsUsecase,
    required this.findMatchUsecase,
  });

  void setState(CurhatChatState s) {
    state = s;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void connectWS() {
    if (_wsConnected) return;
    _wsConnected = true;
    connectWsUsecase.call(
      token: token,
      onEvent: (data) {
        // Debug event masuk dari websocket
        print('[CurhatSobiWsProvider] onEvent: $data');
        // Tangkap baik event websocket maupun response HTTP findMatch
        if (data['event'] == 'matched' ||
            (data['matched_with'] != null && data['room_id'] != null)) {
          roomId = data['room_id'];
          partner = data['matched_with'];
          setState(CurhatChatState.matched);
          if (_context != null) {
            Future.microtask(() {
              GoRouter.of(_context!).go('/curhat-chat-room');
            });
          }
        } else if (data['event'] == 'message' || data['text'] != null) {
          // Tambahkan pesan ke list dan update UI
          // Tandai pesan dari user sendiri (isMe) jika perlu
          final myUserId = partner; // Ganti jika punya userId sendiri
          final msg = Map<String, dynamic>.from(data);
          // Cek apakah pesan dari saya sendiri
          if (msg['user_id'] != null && myUserId != null) {
            msg['is_me'] = msg['user_id'] == myUserId;
          }
          // Jika pesan belum ada di list, tambahkan (hindari duplikat)
          if (messages.isEmpty || messages.last['id'] != msg['id']) {
            messages.add(msg);
            notifyListeners();
          }
        }
      },
      onDone: () {
        print("[CurhatSobiWsProvider] WS closed");
        _wsConnected = false;
      },
      onError: (e) {
        print("[CurhatSobiWsProvider] WS error: $e");
        _wsConnected = false;
      },
    );
  }

  Future<void> findMatch(String role, String category) async {
    // Ambil token terbaru dari AuthDatasources
    final latestToken = await AuthDatasources().getToken() ?? token;
    print('[CurhatSobiWsProvider] findMatch called with:');
    print('  token: $latestToken');
    print('  role: $role');
    print('  category: $category');
    setState(CurhatChatState.searching);

    _findMatchActive = true;
    while (_findMatchActive) {
      final res =
          await findMatchUsecase.call(
                token: latestToken,
                role: role,
                category: category,
              )
              as Map?;
      if (!_findMatchActive) break;
      if (res != null &&
          res['matched_with'] != null &&
          res['room_id'] != null) {
        roomId = res['room_id'];
        partner = res['matched_with'];
        setState(CurhatChatState.matched);
        if (_context != null) {
          Future.microtask(() {
            GoRouter.of(_context!).go('/curhat-chat-room');
          });
        }
        break;
      }
      // Tunggu sebentar sebelum cek lagi (hindari spam request)
      await Future.delayed(const Duration(seconds: 2));
    }
    // Jika matched via websocket, handler tetap berjalan di connectWS
  }

  void stopFindMatch() {
    _findMatchActive = false;
  }

  void sendMessage(String text) {
    if (roomId == null) return;
    // Kirim via WS (atau HTTP jika perlu)
    connectWsUsecase.repository.sendWS({
      "event": "message",
      "room_id": roomId,
      "text": text,
    });
    print('[CurhatSobiWsProvider] sendMessage: $text to room $roomId');
  }

  void leaveChat() {
    roomId = null;
    partner = null;
    messages.clear();
    setState(CurhatChatState.idle);
  }

  void closeWS() {
    connectWsUsecase.repository.closeWS();
    _wsConnected = false;
    print('[CurhatSobiWsProvider] WebSocket closed by user');
  }

  /// Call this in didChangeDependencies or build of every screen that uses CurhatSobiWsProvider
  /// Agar polling findMatch & websocket hanya aktif di 2 screen: curhat matchmaking & curhat chat
  void handleCurhatScreenLifecycle(BuildContext context) {
    final location = GoRouter.of(context).location;
    // Hanya aktif di 2 screen ini
    final isCurhatMatchmaking = location == '/curhat-matchmaking';
    final isCurhatChatRoom = location == '/curhat-chat-room';

    if (!isCurhatMatchmaking && !isCurhatChatRoom) {
      stopFindMatch();
      closeWS();
    }
  }
}
