import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/curhat_sobi_ws_provider.dart';
import '../../../style/colors.dart';
import '../../../style/typography.dart';

class PendengarCurhatScreen extends StatefulWidget {
  const PendengarCurhatScreen({super.key});

  @override
  State<PendengarCurhatScreen> createState() => _PendengarCurhatScreenState();
}

class _PendengarCurhatScreenState extends State<PendengarCurhatScreen> {
  int step = 0;

  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Bisa jadi hari ini, hari terberatnya..',
      'desc':
          'Cerita yang kamu dengar mungkin datang dari seseorang yang sedang benar-benar butuh teman. Hadirmu bisa berarti banget buat dia.',
      'svg': 'assets/illustration/Fatimah-Sedih.svg',
    },
    {
      'title': 'Pelan-pelan ya.',
      'desc':
          'Kamu lagi dengerin seseorang yang mungkin sedang bingung. Jadi, hadirlah dengan hati yang tenang dan jangan terburu-buru dalam merespon.',
      'svg': 'assets/illustration/Fatimah-bingung.svg',
    },
    {
      'title': 'Jadi teman yang nyaman',
      'desc':
          'Mungkin kamu nggak ngerti semua yang dia rasain, tapi kamu bisa tetap jadi teman yang hadir dan bikin dia nyaman buat cerita.',
      'svg': 'assets/illustration/Fatimah-Senang.svg',
    },
    {
      'title': 'Mungkin dia udah lama nyimpan ini.',
      'desc':
          'Cerita yang kamu denger bisa aja udah dipendam lama. Jadi, tanggepin dengan sabar dan empati, bukan buru-buru selesain.',
      'svg': 'assets/illustration/Fatimah-marah.svg',
    },
    {
      'title': 'Siap jadi pendengar yang berarti?',
      'desc':
          'Cerita yang akan kamu dengar mungkin sederhana, mungkin juga dalam. Tapi setiap kata yang kamu balas, bisa jadi kekuatan untuk seseorang yang sedang berjuang. Yuk, hadir dengan hati.',
      'svg': 'assets/svg/curhat_5.svg',
      'isLast': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final stepData = steps[step];
    final isLast = stepData['isLast'] == true;
    final progress = (step + 1) / steps.length;

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
          children: [
            const SizedBox(height: 16),
            // Progress bar
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.primary_10,
                    color: AppColors.primary_30,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${step + 1}/${steps.length}',
                  style: AppTextStyles.body_4_bold.copyWith(
                    color: AppColors.primary_90,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Title
            Text(
              stepData['title'],
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.primary_90,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
            // Deskripsi
            Text(
              stepData['desc'],
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 48),
            // SVG character (hanya jika bukan step terakhir)
            if (!isLast)
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: SizedBox(
                  height: 300,
                  child: Align(
                    alignment: Alignment.center,
                    child:
                        stepData['svg'].toString().endsWith('.svg')
                            ? SvgPicture.asset(
                              stepData['svg'],
                              width: 300,
                              height: 300,
                              fit: BoxFit.contain,
                            )
                            : Image.asset(
                              stepData['svg'],
                              width: 300,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                  ),
                ),
              ),
            // Tombol Latih Diri dan Siap Dengar langsung di bawah deskripsi pada step terakhir
            if (!isLast) const Spacer(),
            if (isLast) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Latih Diri
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_90,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Latih Diri',
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
                    context.push('/curhat-matchmaking'); // <-- navigasi dulu
                    await provider.findMatch("pendengar", "default");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_90,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Siap Dengar',
                    style: AppTextStyles.body_3_bold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            // Tombol bawah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (step > 0 && !isLast)
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          step--;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary_90,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Kembali',
                        style: AppTextStyles.body_3_bold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 140),
                if (!isLast)
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          step++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary_90,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Selanjutnya',
                        style: AppTextStyles.body_3_bold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 140),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
