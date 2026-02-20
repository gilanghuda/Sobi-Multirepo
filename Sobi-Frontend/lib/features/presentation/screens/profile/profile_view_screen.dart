import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/router/app_routes.dart';
import '../../provider/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final screenWidth = MediaQuery.of(context).size.width;
    final profilePicSize = 100.0;

    // Avatar asset mapping
    String avatarAsset = 'assets/profil/Profil 1.png';
    if (user?.avatar != null && user!.avatar != 0) {
      avatarAsset = 'assets/profil/Profil ${user?.avatar}.png';
    }

    // Gender mapping
    String genderText = '-';
    if (user?.gender != null) {
      final g = user?.gender?.toLowerCase();
      if (g == 'male') {
        genderText = 'Ikhwan';
      } else if (g == 'female') {
        genderText = 'Akhwat';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ScrollView isi data user
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 320),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child:
                        user == null
                            ? const Center(child: Text("No user data"))
                            : Column(
                              children: [
                                _ProfileField(
                                  label: 'Nama',
                                  value: user.username ?? '-',
                                ),
                                const SizedBox(height: 16),
                                _ProfileField(
                                  label: 'Nama Pengguna',
                                  value: user.username ?? '-',
                                ),
                                const SizedBox(height: 16),
                                _GenderField(selected: genderText),
                                const SizedBox(height: 16),
                                _ProfileField(
                                  label: 'Email',
                                  value: user.email,
                                ),
                                const SizedBox(height: 16),
                                _ProfileField(
                                  label: 'Nomor Telepon',
                                  value: user.phoneNumber ?? '',
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary_90,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      context.push(AppRoutes.edit_profile);
                                    },
                                    child: Text(
                                      'Edit',
                                      style: AppTextStyles.body_3_bold.copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ),
          // SVG profil background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svg/profil_background.svg',
              width: screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          // Foto profil + nama + tombol edit
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: profilePicSize / 2,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            profilePicSize / 2,
                          ),
                          child: Image.asset(
                            avatarAsset,
                            width: profilePicSize * 0.7,
                            height: profilePicSize * 0.7,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.edit_profile),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary_30,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user?.username ?? '-',
                  style: AppTextStyles.heading_5_bold.copyWith(
                    color: AppColors.default_10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Tombol back di kiri atas
          Positioned(
            top: 38,
            left: 28,
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
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body_3_bold.copyWith(
            color: AppColors.primary_90,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.default_10,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            value,
            style: AppTextStyles.body_3_regular.copyWith(
              color: AppColors.primary_90,
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderField extends StatelessWidget {
  final String selected;
  const _GenderField({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color:
                  selected == 'Akhwat'
                      ? AppColors.primary_10
                      : Colors.transparent,
              border: Border.all(
                color:
                    selected == 'Akhwat'
                        ? AppColors.primary_90
                        : AppColors.default_30,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow:
                  selected == 'Akhwat'
                      ? [
                        BoxShadow(
                          color: AppColors.primary_90.withOpacity(0.15),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            child: Center(
              child: Text(
                'Akhwat👧',
                style: AppTextStyles.body_3_bold.copyWith(
                  color: AppColors.primary_90,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color:
                  selected == 'Ikhwan'
                      ? AppColors.primary_10
                      : Colors.transparent,
              border: Border.all(
                color:
                    selected == 'Ikhwan'
                        ? AppColors.primary_90
                        : AppColors.default_30,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow:
                  selected == 'Ikhwan'
                      ? [
                        BoxShadow(
                          color: AppColors.primary_90.withOpacity(0.15),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            child: Center(
              child: Text(
                'Ikhwan👦',
                style: AppTextStyles.body_3_bold.copyWith(
                  color: AppColors.primary_90,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
