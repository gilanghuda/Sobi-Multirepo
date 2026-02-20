import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/auth_provider.dart';
import 'package:sobi/features/presentation/provider/chat_provider.dart';
import '../../../style/colors.dart';
import '../../../style/typography.dart';

class SobiAiScreen extends StatefulWidget {
  const SobiAiScreen({super.key});

  @override
  State<SobiAiScreen> createState() => _SobiAiScreenState();
}

class _SobiAiScreenState extends State<SobiAiScreen> {
  bool started = false;
  bool waitingBot = false;
  bool showChoices = true;
  List<Map<String, dynamic>> chatHistory = [];
  final TextEditingController _controller = TextEditingController();

  final List<String> firstChoices = [
    'Senang banget sih',
    'Sedikit cemas',
    'Capek banget secara mental',
    'Sedih tanpa alasan',
    'Naik-turun, nggak jelas',
  ];

  String getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';
  }

  void _startChat(String username) {
    setState(() {
      started = true;
      showChoices = true;
      chatHistory = [
        {
          'sender': 'bot',
          'text':
              'Assalammualaikum $username, aku Sobat Bimbing kamu hari ini.',
          'time': getCurrentTime(),
          'is_bot': true,
        },
        {
          'sender': 'bot',
          'text':
              'Gimana kabar kamu hari ini, akhir-akhir ini kamu ngerasa gimana?',
          'time': getCurrentTime(),
          'is_bot': true,
        },
      ];
    });
  }

  Future<void> _sendFirstChoice(
    String choice,
    String token,
    ChatProvider chatProvider,
  ) async {
    setState(() {
      chatHistory.add({
        'sender': 'me',
        'text': choice,
        'time': getCurrentTime(),
        'is_bot': false,
      });
      waitingBot = true;
      showChoices = false;
    });
    // Tampilkan bubble loading bot
    setState(() {
      chatHistory.add({
        'sender': 'bot',
        'text': '...',
        'time': getCurrentTime(),
        'is_bot': true,
        'loading': true,
      });
    });
    await chatProvider.sendBotMessage(token: token, prompt: choice);
    // Debug response di screen
    print('[SobiAiScreen] chatProvider.botReply: ${chatProvider.botReply}');
    // Hapus bubble loading
    setState(() {
      chatHistory.removeWhere((msg) => msg['loading'] == true);
    });
    // Tambahkan response bot
    setState(() {
      chatHistory.add({
        'sender': 'bot',
        'text': chatProvider.botReply ?? '',
        'time': getCurrentTime(),
        'is_bot': true,
      });
      waitingBot = false;
    });
  }

  Future<void> _sendUserMessage(
    String text,
    String token,
    ChatProvider chatProvider,
  ) async {
    setState(() {
      chatHistory.add({
        'sender': 'me',
        'text': text,
        'time': getCurrentTime(),
        'is_bot': false,
      });
      waitingBot = true;
    });
    // Tampilkan bubble loading bot
    setState(() {
      chatHistory.add({
        'sender': 'bot',
        'text': '...',
        'time': getCurrentTime(),
        'is_bot': true,
        'loading': true,
      });
    });
    await chatProvider.sendBotMessage(token: token, prompt: text);
    // Debug response di screen
    print('[SobiAiScreen] chatProvider.botReply: ${chatProvider.botReply}');
    // Hapus bubble loading
    setState(() {
      chatHistory.removeWhere((msg) => msg['loading'] == true);
    });
    // Tambahkan response bot
    setState(() {
      chatHistory.add({
        'sender': 'bot',
        'text': chatProvider.botReply ?? '',
        'time': getCurrentTime(),
        'is_bot': true,
      });
      waitingBot = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final username = authProvider.user?.username ?? 'Sahabat';

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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      'assets/illustration/Fatimah-menyapa.svg',
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
                        'Sobi AI',
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
      body:
          started
              ? _buildChatAi(context, username, chatProvider)
              : _buildLanding(context, username),
    );
  }

  Widget _buildLanding(BuildContext context, String username) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 48),
            child: SvgPicture.asset(
              'assets/illustration/Fatimah-menyapa.svg',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 200),
                Card(
                  color: AppColors.primary_10,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Cerita nggak harus selalu ke manusia',
                          style: AppTextStyles.heading_4_bold.copyWith(
                            color: AppColors.primary_90,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Di fitur ini, AI bakal mulai ngobrol dulu lewat beberapa pertanyaan ringan buat ngerti perasaan kamu—biar curhatnya lebih terarah dan insyaAllah bisa bantu kamu ngerasa lebih lega.',
                          style: AppTextStyles.body_4_regular.copyWith(
                            color: AppColors.primary_90,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _startChat(username),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary_90,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Mulai',
                              style: AppTextStyles.body_3_bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatAi(
    BuildContext context,
    String username,
    ChatProvider chatProvider,
  ) {
    final token = Provider.of<AuthProvider>(context, listen: false).token ?? '';
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Today',
              style: AppTextStyles.body_4_bold.copyWith(
                color: AppColors.primary_90,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: chatHistory.length,
            itemBuilder: (context, idx) {
              final msg = chatHistory[idx];
              if (msg['is_bot'] == true) {
                if (msg['loading'] == true) {
                  return _bubbleBotLoading();
                }
                return _bubbleAi(msg['text'], msg['time']);
              } else {
                return _bubbleMe(msg['text'], msg['time']);
              }
            },
          ),
        ),
        if (showChoices)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                ...firstChoices.map((choice) {
                  final isSelected =
                      chatHistory.isNotEmpty &&
                      chatHistory.last['sender'] == 'me' &&
                      chatHistory.last['text'] == choice;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            waitingBot
                                ? null
                                : () => _sendFirstChoice(
                                  choice,
                                  token,
                                  chatProvider,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? AppColors.primary_30 : Colors.white,
                          elevation: 2, // tambahkan shadow
                          shadowColor: Colors.black.withOpacity(0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: AppColors.default_30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          choice,
                          style: AppTextStyles.body_4_bold.copyWith(
                            // bold typography
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppColors.primary_90,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !waitingBot,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      hintStyle: AppTextStyles.body_4_regular.copyWith(
                        color: AppColors.default_90,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (val) async {
                      if (val.trim().isEmpty || waitingBot) return;
                      await _sendUserMessage(val.trim(), token, chatProvider);
                      _controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary_90),
                  onPressed:
                      waitingBot
                          ? null
                          : () async {
                            final val = _controller.text.trim();
                            if (val.isEmpty) return;
                            await _sendUserMessage(val, token, chatProvider);
                            _controller.clear();
                          },
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _bubbleAi(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
          right: 60,
        ), // tambahkan right margin agar tidak tabrakan
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary_10,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: const Radius.circular(6),
            bottomRight: const Radius.circular(
              18,
            ), // sudut kanan bawah lebih kecil
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: AppTextStyles.body_5_regular.copyWith(
                color: AppColors.default_90,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubbleMe(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
          left: 60,
        ), // tambahkan left margin agar tidak tabrakan
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary_30,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: const Radius.circular(
              18,
            ), // sudut kiri bawah lebih kecil
            bottomRight: const Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: AppTextStyles.body_4_regular.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: AppTextStyles.body_5_regular.copyWith(
                color: AppColors.default_90,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubbleBotLoading() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary_10,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 16,
              child: Row(
                children: [
                  _dot(),
                  const SizedBox(width: 2),
                  _dot(delay: 200),
                  const SizedBox(width: 2),
                  _dot(delay: 400),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Sobi AI sedang mengetik...',
              style: AppTextStyles.body_5_regular.copyWith(
                color: AppColors.primary_90,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot({int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary_90,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }
}
