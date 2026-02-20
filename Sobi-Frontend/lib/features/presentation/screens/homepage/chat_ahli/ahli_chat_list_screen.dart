import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/data/datasources/auth_datasources.dart';
import 'package:sobi/features/presentation/provider/chat_provider.dart';
import 'package:sobi/features/presentation/provider/ahli_provider.dart';
import '../../../style/colors.dart';
import '../../../style/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AhliChatListScreen extends StatefulWidget {
  const AhliChatListScreen({super.key});

  @override
  State<AhliChatListScreen> createState() => _AhliChatListScreenState();
}

class _AhliChatListScreenState extends State<AhliChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final token = await AuthDatasources().getToken() ?? '';
      await chatProvider.fetchRecentChats(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final ahliProvider = Provider.of<AhliProvider>(context, listen: false);
    final recentChats = chatProvider.recentChats;

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
        title: const Text('Chat'),
        backgroundColor: AppColors.primary_10,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: recentChats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, idx) {
          final chat = recentChats[idx];
          return FutureBuilder<Map<String, dynamic>?>(
            future: ahliProvider.getUserByIdUsecase?.call(chat.otherUserId),
            builder: (context, snapshot) {
              final user = snapshot.data;
              final avatar = user?['avatar']?.toString() ?? '1';
              final username = user?['username'] ?? 'User';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary_10,
                  backgroundImage: AssetImage(
                    'assets/profil/Profil $avatar.png',
                  ),
                ),
                title: Text(
                  username,
                  style: AppTextStyles.body_4_bold.copyWith(
                    color: AppColors.primary_90,
                  ),
                ),
                subtitle: Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body_4_regular.copyWith(
                    color: AppColors.primary_90,
                  ),
                ),
                trailing: Text(
                  _formatTime(chat.lastAt),
                  style: AppTextStyles.body_5_regular.copyWith(
                    color: AppColors.default_90,
                  ),
                ),
                onTap: () {
                  context.push(
                    '/ahli-chat',
                    extra: {
                      'roomId': chat.roomId,
                      'otherUserId': chat.otherUserId,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
