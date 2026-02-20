import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sobi/features/presentation/style/colors.dart';
import 'package:sobi/features/presentation/style/typography.dart';
import 'package:lottie/lottie.dart';
import '../../../provider/curhat_sobi_ws_provider.dart';

class CurhatMatchmakingScreen extends StatefulWidget {
  const CurhatMatchmakingScreen({super.key});

  @override
  State<CurhatMatchmakingScreen> createState() =>
      _CurhatMatchmakingScreenState();
}

class _CurhatMatchmakingScreenState extends State<CurhatMatchmakingScreen> {
  bool _navigatingToChat = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<CurhatSobiWsProvider>(context, listen: false);
    provider.setContext(context);
    provider.handleCurhatScreenLifecycle(context);
  }

  @override
  void dispose() {
    // Cek apakah user sedang menuju ke chat screen
    final router = GoRouter.of(context);
    if (!_navigatingToChat && router.location != '/curhat-chat-room') {
      final provider = Provider.of<CurhatSobiWsProvider>(
        context,
        listen: false,
      );
      provider.closeWS();
      provider.stopFindMatch(); // <-- stop polling findMatch
    }
    super.dispose();
  }

  void _goToChatRoom(BuildContext context) {
    _navigatingToChat = true;
    context.push('/curhat-chat-room');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider = Provider.of<CurhatSobiWsProvider>(
          context,
          listen: false,
        );
        provider.closeWS();
        provider.stopFindMatch(); // <-- stop polling findMatch
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<CurhatSobiWsProvider>(
          builder: (context, chat, _) {
            // Set context untuk provider agar bisa auto-navigate saat matched
            chat.setContext(context);
            if (chat.state == CurhatChatState.idle) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: "pencerita",
                      items:
                          ["pendengar", "pencerita"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (_) {},
                    ),
                    ElevatedButton(
                      onPressed: () {
                        chat.findMatch("pencerita", "default");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary_90,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                      ),
                      child: Text(
                        "Find Match",
                        style: AppTextStyles.body_3_bold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (chat.state == CurhatChatState.searching) {
              // Tampilkan loading Lottie
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child:
                      // Ganti Placeholder dengan Lottie
                      // Pastikan package lottie sudah diimport
                      Lottie.asset(
                        'assets/lottie/Time Hourglass.json',
                        repeat: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Mencari teman curhat...",
                      style: AppTextStyles.heading_5_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                  ],
                ),
              );
            } else if (chat.state == CurhatChatState.matched) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primary_30,
                      size: 64,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Teman ditemukan!",
                      style: AppTextStyles.heading_5_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Room: ${chat.roomId ?? '-'}",
                      style: AppTextStyles.body_4_regular.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: () => _goToChatRoom(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary_90,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Hubungkan",
                          style: AppTextStyles.body_3_bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // chatting
              return const _CurhatChatScreen();
            }
          },
        ),
      ),
    );
  }
}

class _CurhatChatScreen extends StatelessWidget {
  const _CurhatChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<CurhatSobiWsProvider>(context);
    final msgCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Curhat Anonim",
          style: AppTextStyles.heading_5_bold.copyWith(
            color: AppColors.primary_90,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: chat.messages.length,
              itemBuilder: (ctx, i) {
                final msg = chat.messages[i];
                final isMe =
                    msg['user_id'] ==
                    chat.partner; // sesuaikan jika ada userId sendiri
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary_30 : AppColors.primary_10,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'] ?? '',
                          style: AppTextStyles.body_4_regular.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['user_id']?.toString() ?? '',
                          style: AppTextStyles.body_5_regular.copyWith(
                            color: AppColors.default_90,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.primary_10, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      hintStyle: AppTextStyles.body_4_regular.copyWith(
                        color: AppColors.default_90,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) {
                      chat.sendMessage(msgCtrl.text);
                      msgCtrl.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary_90),
                  onPressed: () {
                    chat.sendMessage(msgCtrl.text);
                    msgCtrl.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
