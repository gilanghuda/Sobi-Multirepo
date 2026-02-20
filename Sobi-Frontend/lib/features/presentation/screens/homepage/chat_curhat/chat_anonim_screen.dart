import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../style/colors.dart';
import '../../../style/typography.dart';
import '../../../provider/curhat_sobi_ws_provider.dart';


class ChatAnonimScreen extends StatelessWidget {
  const ChatAnonimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Curhat Anonim',
          style: AppTextStyles.heading_5_bold.copyWith(
            color: AppColors.primary_90,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              'Kamu ingin berperan sebagai apa dalam sesi ini?',
              style: AppTextStyles.heading_5_bold.copyWith(
                color: AppColors.primary_90,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/pendengar-curhat');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_90,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Pendengar',
                  style: AppTextStyles.body_3_bold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = Provider.of<CurhatSobiWsProvider>(
                    context,
                    listen: false,
                  );
                  provider.connectWS();
                  await provider.findMatch("pencerita", "default");
                  context.push('/curhat-matchmaking');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_90,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Pencerita',
                  style: AppTextStyles.body_3_bold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

