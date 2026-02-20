import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom curved appbar
          Stack(
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary_10,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
              Positioned(
                top: 38,
                left: 18,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(-1.0, 1.0),
                    child: SvgPicture.asset(
                      'assets/icons/arrow-circle-right.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 38,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'FAQs',
                    style: AppTextStyles.heading_5_bold.copyWith(
                      color: AppColors.primary_90,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batuh Bantuan',
                      style: AppTextStyles.heading_4_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Punya pertanyaan soal fitur atau cara pakai? Langsung aja tanya di sini!',
                      style: AppTextStyles.body_3_regular.copyWith(
                        color: AppColors.default_90,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // FAQ List
                    _FaqItem(
                      icon: Icons.mail_outline,
                      question: 'Apa itu SoBi (صبي)?',
                      answer:
                          'SoBi adalah aplikasi pendamping islami untuk remaja yang ingin menjaga diri dari pergaulan bebas dan memperbaiki diri secara spiritual serta emosional. SoBi menyediakan tracker ibadah, jurnal refleksi, analisis emosi, serta konten islami seperti podcast dan artikel sebagai temon hijrah yang sesuai syariat.',
                    ),
                    const SizedBox(height: 18),
                    _FaqItem(
                      icon: Icons.mail_outline,
                      question: 'Siapa yang bisa menggunakan SoBi?',
                      answer:
                          'Aplikasi ini dirancang khusus untuk remaja muslim, terutama yang sedang berjuang menghindari pengaruh negatif lingkungan dan ingin lebih dekat dengan nilai-nilai Al-Qur’an dan Hadits.',
                    ),
                    const SizedBox(height: 18),
                    _FaqItem(
                      icon: Icons.mail_outline,
                      question: 'Apakah data jurnal dan curhat saya aman?',
                      answer:
                          'Ya. Data pengguna disimpan dengan aman dan hanya bisa diakses oleh akun pribadi. SoBi menjunjung tinggi privasi dan keamanan pengguna.',
                    ),
                    const SizedBox(height: 18),
                    _FaqItem(
                      icon: Icons.mail_outline,
                      question: 'Apakah SoBi bisa digunakan oleh orang dewasa?',
                      answer:
                          'SoBi dirancang untuk remaja, orang dewasa yang merasa butuh bimbingan islami dan refleksi diri tetap dapat menggunakan aplikasi ini.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final IconData icon;
  final String question;
  final String answer;
  const _FaqItem({
    required this.icon,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary_10,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary_90, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: AppTextStyles.body_3_bold.copyWith(
                  color: AppColors.primary_90,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                answer,
                style: AppTextStyles.body_3_regular.copyWith(
                  color: AppColors.default_90,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
