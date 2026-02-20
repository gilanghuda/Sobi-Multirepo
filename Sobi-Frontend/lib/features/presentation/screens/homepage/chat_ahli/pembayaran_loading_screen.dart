import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/data/datasources/auth_datasources.dart';
import 'package:sobi/features/presentation/provider/chat_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../../../style/colors.dart';
import '../../../style/typography.dart';

class PembayaranLoadingScreen extends StatefulWidget {
  final Map<String, dynamic>? ahli;
  const PembayaranLoadingScreen({super.key, this.ahli});

  @override
  State<PembayaranLoadingScreen> createState() =>
      _PembayaranLoadingScreenState();
}

class _PembayaranLoadingScreenState extends State<PembayaranLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint('[PEMBAYARAN LOADING] ahli.id: ${widget.ahli?['id']}');
      context.go('/pembayaran-berhasil', extra: widget.ahli);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ahli = widget.ahli;
    debugPrint('[PEMBAYARAN LOADING] ahli object: ${ahli.toString()}');
    debugPrint('[PEMBAYARAN LOADING] ahli.id: ${ahli?['id']}');
    debugPrint('[PEMBAYARAN LOADING] ahli.username: ${ahli?['username']}');
    debugPrint('[PEMBAYARAN LOADING] ahli.avatar: ${ahli?['avatar']}');
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
        title: Text(
          'Menunggu Pembayaran',
          style: AppTextStyles.heading_5_bold.copyWith(
            color: AppColors.primary_90,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasi Lottie hourglass
              SizedBox(
                height: 160,
                child:
                // Ganti dengan Lottie looping
                // Pastikan package lottie sudah diimport
                Lottie.asset('assets/lottie/Time Hourglass.json', repeat: true),
              ),
              const SizedBox(height: 32),
              Text(
                'Mohon untuk segera melakukan pembayaran sebelum batas waktu pembayaran.',
                style: AppTextStyles.body_4_regular.copyWith(
                  color: AppColors.primary_90,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                color: AppColors.primary_10,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailRow(label: 'Kode Booking', value: 'AA230425'),
                      _DetailRow(label: 'Batas Waktu', value: '23 April 2025'),
                      _DetailRow(label: 'Pembayaran', value: '10:41'),
                      _DetailRow(
                        label: 'Metode Pembayaran',
                        value: 'Shopeepay',
                      ),
                      _DetailRow(label: 'Total Pembayaran', value: 'Rp 27.000'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
            ),
          ),
          Text(
            ':',
            style: AppTextStyles.body_4_regular.copyWith(
              color: AppColors.primary_90,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body_4_bold.copyWith(
                color: AppColors.primary_90,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PembayaranBerhasilScreen extends StatelessWidget {
  final Map<String, dynamic>? ahli;
  const PembayaranBerhasilScreen({super.key, this.ahli});

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Pembayaran Berhasil',
          style: AppTextStyles.heading_5_bold.copyWith(
            color: AppColors.primary_90,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Checklist besar dan center
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary_30, width: 6),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 120,
                    color: AppColors.primary_30,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Selanjutnya kamu akan diarahkan ke sesi curhat bersama ahli',
                style: AppTextStyles.body_4_regular.copyWith(
                  color: AppColors.primary_90,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final ahliData =
                        ahli ??
                        (GoRouter.of(
                              context,
                            ).routerDelegate.currentConfiguration.extra
                            as Map<String, dynamic>?);
                    final targetId = ahliData?['id'] ?? '';
                    debugPrint(
                      '[PEMBAYARAN BERHASIL] createRoom targetId: $targetId',
                    );
                    final token = await AuthDatasources().getToken() ?? '';
                    final chatProvider = Provider.of<ChatProvider>(
                      context,
                      listen: false,
                    );
                    await chatProvider.createRoom(
                      token: token,
                      category: 'curhat',
                      visible: true,
                      targetId: targetId,
                    );
                    final roomId = chatProvider.createdRoom?.id ?? '';
                    debugPrint('[PEMBAYARAN BERHASIL] roomId: $roomId');
                    await chatProvider.fetchRoomMessages(
                      token: token,
                      roomId: roomId,
                    );
                    context.go(
                      '/chat-room/ahli',
                      extra: {'roomId': roomId, 'ahli': ahliData},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_90,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Lanjut Sesi Chat',
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
    );
  }
}
