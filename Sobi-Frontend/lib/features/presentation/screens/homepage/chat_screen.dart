import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/data/datasources/auth_datasources.dart';
import 'package:sobi/features/presentation/provider/chat_provider.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

class ChatScreen extends StatefulWidget {
  final String role;
  final String? roomId;
  final Map<String, dynamic>? ahli;
  const ChatScreen({super.key, required this.role, this.roomId, this.ahli});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('[CHAT SCREEN] ahli.id: ${widget.ahli?['id']}');
    if (widget.roomId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        debugPrint(
          '[CHAT SCREEN] roomId: ${widget.roomId}, ahli.id: ${widget.ahli?['id']}',
        );
        final token = await AuthDatasources().getToken() ?? '';
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        await chatProvider.fetchRoomMessages(
          token: token,
          roomId: widget.roomId!,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || widget.roomId == null) return;
    final token = await AuthDatasources().getToken() ?? '';
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.sendMessage(
      token: token,
      roomId: widget.roomId!,
      text: text,
    );
    _messageController.clear();
    // Fetch history chat agar real-time
    await chatProvider.fetchRoomMessages(token: token, roomId: widget.roomId!);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.messages;

    debugPrint('[CHAT SCREEN] ahli object: ${widget.ahli.toString()}');
    debugPrint('[CHAT SCREEN] ahli.id: ${widget.ahli?['id']}');
    debugPrint('[CHAT SCREEN] ahli.username: ${widget.ahli?['username']}');
    debugPrint('[CHAT SCREEN] ahli.avatar: ${widget.ahli?['avatar']}');
    // Group messages by date
    Map<String, List<dynamic>> grouped = {};
    for (var msg in messages) {
      // Ambil tanggal dari createdAt (format: yyyy-MM-ddTHH:mm:ss)
      final dateStr = msg.createdAt.split('T').first;
      grouped.putIfAbsent(dateStr, () => []).add(msg);
    }
    // Urutkan tanggal ascending
    final sortedDates = grouped.keys.toList()..sort((a, b) => a.compareTo(b));

    String _monthName(int month) {
      const months = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return months[month];
    }

    // Helper untuk label tanggal
    String getDateLabel(String dateStr) {
      final now = DateTime.now();
      final msgDate = DateTime.tryParse(dateStr) ?? now;
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      if (msgDate.year == today.year &&
          msgDate.month == today.month &&
          msgDate.day == today.day) {
        return 'Today';
      } else if (msgDate.year == yesterday.year &&
          msgDate.month == yesterday.month &&
          msgDate.day == yesterday.day) {
        return 'Yesterday';
      } else {
        return '${msgDate.day} ${_monthName(msgDate.month)}';
      }
    }

    String formatTime(String createdAt) {
      // Format jam:menit dari createdAt
      try {
        final dt = DateTime.parse(createdAt);
        return '${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        return createdAt;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary_10,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary_90,
                    ),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      } else {
                        context.go('/navbar');
                      }
                    },
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      'assets/svg/avatar.svg',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ahli?['username'] ?? 'User_ahli',
                        style: AppTextStyles.heading_6_bold.copyWith(
                          color: AppColors.primary_90,
                        ),
                      ),
                      Text(
                        'Online',
                        style: AppTextStyles.body_5_regular.copyWith(
                          color: AppColors.primary_90,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: sortedDates.length,
              itemBuilder: (context, dateIdx) {
                final dateStr = sortedDates[dateIdx];
                final msgList = grouped[dateStr]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          getDateLabel(dateStr),
                          style: AppTextStyles.body_4_bold.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                      ),
                    ),
                    ...msgList.map((msg) {
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
                                formatTime(msg.createdAt),
                                style: AppTextStyles.body_5_bold.copyWith(
                                  color: AppColors.primary_90,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          // Input bar
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
                Icon(Icons.camera_alt_outlined, color: AppColors.primary_90),
                const SizedBox(width: 8),
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
                Icon(Icons.link, color: AppColors.primary_90),
                const SizedBox(width: 8),
                Icon(Icons.image_outlined, color: AppColors.primary_90),
                const SizedBox(width: 8),
                Icon(Icons.mic_none_outlined, color: AppColors.primary_90),
                const SizedBox(width: 8),
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
}
