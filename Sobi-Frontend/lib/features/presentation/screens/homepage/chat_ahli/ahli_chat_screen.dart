import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/chat_provider.dart';
import 'package:sobi/features/presentation/provider/ahli_provider.dart';
import 'package:sobi/features/data/datasources/auth_datasources.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../style/colors.dart';
import '../../../style/typography.dart';

class AhliChatScreen extends StatefulWidget {
  final String roomId;
  final String otherUserId;
  const AhliChatScreen({
    super.key,
    required this.roomId,
    required this.otherUserId,
  });

  @override
  State<AhliChatScreen> createState() => _AhliChatScreenState();
}

class _AhliChatScreenState extends State<AhliChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final ahliProvider = Provider.of<AhliProvider>(context, listen: false);
      final token = await AuthDatasources().getToken() ?? '';
      print(
        '[AhliChatScreen] Fetching room messages for roomId=${widget.roomId}',
      );
      await chatProvider.fetchRoomMessages(token: token, roomId: widget.roomId);
      user = await ahliProvider.getUserByIdUsecase?.call(widget.otherUserId);
      print('[AhliChatScreen] user fetched: $user');
      setState(() {});
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final token = await AuthDatasources().getToken() ?? '';
    await chatProvider.sendMessage(
      token: token,
      roomId: widget.roomId,
      text: text,
    );
    _messageController.clear();
    await chatProvider.fetchRoomMessages(token: token, roomId: widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.messages;
    final avatar = user?['avatar']?.toString() ?? '1';
    final username = user?['username'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0),
            child: SvgPicture.asset(
              'assets/icons/arrow-circle-right.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.primary_90,
                BlendMode.srcIn,
              ),
            ),
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary_10,
              backgroundImage: AssetImage('assets/profil/Profil $avatar.png'),
            ),
            const SizedBox(width: 12),
            Text(
              username,
              style: AppTextStyles.heading_6_bold.copyWith(
                color: AppColors.primary_90,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary_10,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, idx) {
                final msg = messages[idx];
                // Gunakan langsung msg.isMe
                final isMe = msg.isMe;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 260),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isMe
                              ? AppColors.primary_30
                              : AppColors.primary_10,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 16 : 0),
                        topRight: Radius.circular(isMe ? 0 : 16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: AppTextStyles.body_4_regular.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(msg.createdAt),
                          style: AppTextStyles.body_5_bold.copyWith(
                            color: AppColors.primary_90,
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
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: AppTextStyles.body_4_regular.copyWith(
                        color: AppColors.default_90,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary_90),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt);
      return '${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return createdAt;
    }
  }
}
