import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/auth_provider.dart';

import 'package:sobi/features/presentation/router/app_routes.dart';
import 'package:sobi/features/presentation/style/colors.dart';
import 'package:sobi/features/presentation/style/typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _LogoutConfirmDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profilePicSize = 100.0;
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.user?.username ?? '-';
    final avatar = authProvider.user?.avatar ?? 1;
    final avatarAsset = 'assets/profil/Profil $avatar.png';

    final List<_SettingsMenuItem> menuItems = [
      _SettingsMenuItem(
        icon: 'assets/icons/profile.svg',
        title: 'Profil',
        onTap: () => context.push(AppRoutes.view_profile),
      ),
      _SettingsMenuItem(
        icon: 'assets/icons/edit_profil.png', // ganti ke PNG
        title: 'Edit Profil',
        onTap: () {
          context.push(AppRoutes.edit_profile);
        },
      ),
      _SettingsMenuItem(
        icon: 'assets/icons/mdi_faq.png', // ganti ke PNG
        title: 'FAQ',
        onTap: () => context.push(AppRoutes.faq),
      ),
      _SettingsMenuItem(
        icon: 'assets/icons/about.png', // ganti ke PNG
        title: 'Tentang Aplikasi',
        onTap: () => context.push(AppRoutes.about),
      ),
      _SettingsMenuItem(
        icon: 'assets/icons/logout.png', // ganti ke PNG
        title: 'Keluar',
        onTap: () => _showLogoutDialog(context),
        isLogout: true,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ScrollView isi menu
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 350),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        ...menuItems.map(
                          (item) => Column(
                            children: [
                              _SettingsMenuCard(item: item),
                              if (!item.isLogout)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Divider(
                                    color: AppColors.default_30,
                                    thickness: 1,
                                    height: 1,
                                  ),
                                ),
                              if (item.isLogout) const SizedBox(height: 8),
                            ],
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
                            child: Icon(
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
                  username,
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

class _SettingsMenuItem {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;
  const _SettingsMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });
}

class _SettingsMenuCard extends StatelessWidget {
  final _SettingsMenuItem item;
  const _SettingsMenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isSvg = item.icon.endsWith('.svg');
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary_90,
                shape: BoxShape.circle,
              ),
              child: Center(
                child:
                    isSvg
                        ? SvgPicture.asset(
                          item.icon,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                        : Image.asset(
                          item.icon,
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.body_3_bold.copyWith(
                  color: AppColors.primary_90,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black, size: 28),
          ],
        ),
      ),
    );
  }
}

// Pop up 1: Konfirmasi keluar
class _LogoutConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/illustration/Fatimah-Sedih.svg', // ganti ke svg/png sesuai asset
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Keluar',
              style: AppTextStyles.heading_5_bold.copyWith(
                color: AppColors.primary_90,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kamu yakin ingin keluar akun ini?',
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.default_30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: AppTextStyles.body_4_bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Tunggu proses logout selesai
                      await authProvider.logout();
                      // Tutup dialog konfirmasi
                      Navigator.of(context).pop();
                      // Tampilkan dialog sukses
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => _LogoutSuccessDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Keluar',
                      style: AppTextStyles.body_4_bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pop up 2: Sukses keluar
class _LogoutSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/svg/fatimah_senang.png', // ganti ke svg/png sesuai asset
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Berhasil',
              style: AppTextStyles.heading_5_bold.copyWith(
                color: AppColors.primary_90,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selamat kamu berhasil keluar aplikasi',
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  context.go(AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Lanjutkan',
                  style: AppTextStyles.body_4_bold.copyWith(
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
