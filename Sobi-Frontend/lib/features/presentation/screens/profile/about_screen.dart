import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                    'Tentang Aplikasi',
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
                      'Tentang Aplikasi SoBi (صبي)',
                      style: AppTextStyles.heading_4_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'SoBi adalah aplikasi pendamping remaja muslim yang hadir sebagai solusi islami atas tantangan pergaulan bebas, kesehatan mental, dan pencarian jati diri di era modern. Nama SoBi diambil dari bahasa Arab yang juga berarti anak muda, mencerminkan semangat aplikasi ini sebagai sahabat setia dalam proses hijrah dan pembentukan karakter islami yang kuat.\n\nMisi SoBi:\nMenjadi ruang aman dan penuh makna bagi remaja muslim untuk menjaga hati, jiwa, dan pergaulan dengan bimbingan Al-Qur’an dan Hadits.\n\nApa yang Membuat SoBi Berbeda?\n• Pendekatan islami dan Syariah-Friendly\n• AI sebagai Teman Cerita Islami\n• Tracker Ibadah & Jurnal Refleksi\n• Konten Islami yang Relevan\n\nFitur-Fitur Unggulan SoBi:\n• Tracker Ibadah Harian\n• Jurnal Emosi dan Refleksi\n• AI Sahabat Cerita\n• Konten Edukasi Islami\n• Analisis Hubungan & Emosi\n\nUntuk Siapa Aplikasi Ini?\n• Remaja muslim yang ingin menjaga diri dari pengaruh bebas\n• Pengguna yang sedang proses hijrah dan mencari bimbingan syari\n• Siapapun yang ingin mendekatkan mental kepada nilai-nilai Islam.',
                      style: AppTextStyles.body_3_regular.copyWith(
                        color: AppColors.primary_90,
                      ),
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
