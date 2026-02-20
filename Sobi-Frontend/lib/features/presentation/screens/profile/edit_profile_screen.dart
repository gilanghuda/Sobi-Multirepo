import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController telpController;
  String gender = 'Akhwat';

  int selectedAvatar = 0;

  // Ganti avatarAssets dengan daftar asset avatar
  final List<String> avatarAssets = List.generate(
    6,
    (i) => 'assets/profil/Profil ${i + 1}.png',
  );

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    namaController = TextEditingController(text: user?.username ?? '');
    usernameController = TextEditingController(text: user?.username ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    telpController = TextEditingController(text: user?.phoneNumber ?? '');
    if (user?.gender != null) {
      gender = user!.gender!.toLowerCase() == 'male' ? 'Ikhwan' : 'Akhwat';
    }
    // avatar: pastikan int
    if (user?.avatar != null) {
      final idx = int.tryParse(user!.avatar.toString()) ?? 1;
      selectedAvatar = (idx - 1).clamp(0, avatarAssets.length - 1);
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    emailController.dispose();
    telpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const profilePicSize = 100.0;
    final user = Provider.of<AuthProvider>(context).user;

    // Avatar asset mapping
    String avatarAsset = avatarAssets[selectedAvatar];

    // Gender mapping (same as view screen)
    String genderText = '-';
    if (user?.gender != null) {
      genderText = user?.gender?.toLowerCase() == 'male' ? 'Ikhwan' : 'Akhwat';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ScrollView isi form edit
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 320),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Show avatar and username above the form fields
                        Column(children: [const SizedBox(height: 24)]),
                        _EditProfileField(
                          label: 'Nama',
                          controller: namaController,
                        ),
                        const SizedBox(height: 16),
                        _EditProfileField(
                          label: 'Nama Pengguna',
                          controller: usernameController,
                        ),
                        const SizedBox(height: 16),
                        _GenderEditField(
                          gender: gender,
                          onChanged: (val) => setState(() => gender = val),
                        ),
                        const SizedBox(height: 16),
                        // Email tidak bisa diubah
                        _EditProfileField(
                          label: 'Email',
                          controller: emailController,
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        _EditProfileField(
                          label: 'Nomor Telepon',
                          controller: telpController,
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () async {
                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            // Mapping gender ke backend value
                            String genderValue =
                                gender == 'Ikhwan' ? 'male' : 'female';
                            // Avatar index ke int
                            int avatarValue = selectedAvatar + 1;
                            await authProvider.updateUserProfile(
                              username: usernameController.text,
                              gender: genderValue,
                              phoneNumber: telpController.text,
                              avatar: avatarValue,
                            );
                            _showProfileSuccessDialog(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary_90,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Simpan',
                                style: AppTextStyles.body_3_bold.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
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
          // Foto profil + pilihan avatar
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
                            avatarAssets[selectedAvatar],
                            width: profilePicSize * 0.7,
                            height: profilePicSize * 0.7,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Pilihan avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(avatarAssets.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                selectedAvatar == index
                                    ? AppColors.primary_90
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Image.asset(
                            avatarAssets[index],
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
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
                    'assets/illustration/Fatimah-Senang.svg',
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
                    'Selamat kamu berhasil mengganti profil',
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
                        Navigator.of(context).pop(); // tutup dialog
                        Navigator.of(
                          context,
                        ).pop(); // kembali ke screen sebelumnya
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
          ),
    );
  }
}

class _EditProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  const _EditProfileField({
    required this.label,
    required this.controller,
    this.enabled = true,
  });

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
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: AppTextStyles.body_3_regular.copyWith(
              color: AppColors.primary_90,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}

class _GenderEditField extends StatelessWidget {
  final String gender;
  final ValueChanged<String> onChanged;
  const _GenderEditField({required this.gender, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged('Akhwat'),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color:
                    gender == 'Akhwat'
                        ? AppColors.primary_10
                        : Colors.transparent,
                border: Border.all(
                  color:
                      gender == 'Akhwat'
                          ? AppColors.primary_90
                          : AppColors.default_30,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
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
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged('Ikhwan'),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color:
                    gender == 'Ikhwan'
                        ? AppColors.primary_10
                        : Colors.transparent,
                border: Border.all(
                  color:
                      gender == 'Ikhwan'
                          ? AppColors.primary_90
                          : AppColors.default_30,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
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
        ),
      ],
    );
  }
}
