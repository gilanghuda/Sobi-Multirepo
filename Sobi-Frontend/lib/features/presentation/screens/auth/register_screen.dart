import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sobi/features/presentation/style/colors.dart';
import 'package:sobi/features/presentation/style/typography.dart';
import '../../router/app_routes.dart';
import '../../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController setPasswordController = TextEditingController();

  bool agreeTerms = false;

  bool get isFormValid =>
      emailController.text.isNotEmpty &&
      namaController.text.isNotEmpty &&
      telpController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      setPasswordController.text.isNotEmpty &&
      agreeTerms;

  @override
  void initState() {
    super.initState();
    namaController.addListener(_updateState);
    emailController.addListener(_updateState);
    telpController.addListener(_updateState);
    passwordController.addListener(_updateState);
    setPasswordController.addListener(_updateState);
  }

  void _updateState() {
    // Pastikan setState hanya dipanggil jika widget masih mounted
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    namaController.removeListener(_updateState);
    emailController.removeListener(_updateState);
    telpController.removeListener(_updateState);
    passwordController.removeListener(_updateState);
    setPasswordController.removeListener(_updateState);
    super.dispose();
  }

  void _register() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!agreeTerms) {
      Fluttertoast.showToast(msg: 'Anda harus menyetujui syarat dan ketentuan');
      return;
    }
    if (passwordController.text != setPasswordController.text) {
      Fluttertoast.showToast(msg: 'Password dan ulangi password tidak sama');
      return;
    }
    if (emailController.text.isEmpty ||
        namaController.text.isEmpty ||
        telpController.text.isEmpty ||
        passwordController.text.isEmpty ||
        setPasswordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Semua field harus diisi');
      return;
    }
    await authProvider.signUp(
      emailController.text,
      namaController.text,
      telpController.text,
      passwordController.text,
    );
    if (authProvider.error == null) {
      Fluttertoast.showToast(msg: 'Registrasi berhasil');
      context.go('${AppRoutes.verif}/${emailController.text}');
    } else {
      Fluttertoast.showToast(msg: authProvider.error ?? 'Register gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: -10,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: SvgPicture.asset(
                  'assets/svg/login_background.svg',
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Daftar',
                      style: AppTextStyles.heading_4_bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Buat akun untuk melanjutkan!',
                      style: AppTextStyles.body_4_regular.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Nama
                    _RegisterField(
                      label: 'Nama',
                      controller: namaController,
                      hint: 'Nama',
                    ),
                    const SizedBox(height: 16),
                    // Email
                    _RegisterField(
                      label: 'Email',
                      controller: emailController,
                      hint: 'Email',
                    ),
                    const SizedBox(height: 16),
                    // Nomor Telepon
                    _RegisterField(
                      label: 'Nomor Telepon',
                      controller: telpController,
                      hint: 'Masukkan nomor',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    // Kata Sandi
                    _RegisterField(
                      label: 'Kata Sandi',
                      controller: passwordController,
                      hint: 'Kata sandi',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    // Set Kata Sandi
                    _RegisterField(
                      label: 'Set Kata Sandi',
                      controller: setPasswordController,
                      hint: 'Kata sandi',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: agreeTerms,
                          onChanged: (val) {
                            setState(() => agreeTerms = true ?? false);
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Saya menyetujui syarat dan ketentuan',
                            style: AppTextStyles.body_4_regular.copyWith(
                              color: AppColors.primary_90,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: isFormValid ? _register : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: double.infinity,
                        height: 56,
                        decoration: ShapeDecoration(
                          color:
                              isFormValid
                                  ? AppColors.primary_90
                                  : AppColors.default_70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Daftar',
                            style: AppTextStyles.body_2_bold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Atau',
                        style: AppTextStyles.body_3_regular.copyWith(
                          color: AppColors.default_90,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Google Login Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: ShapeDecoration(
                        color: AppColors.primary_10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: AppColors.primary_90,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0C000000),
                                  blurRadius: 10,
                                  offset: Offset(2, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Lanjutkan dengan Google',
                            style: AppTextStyles.body_4_regular.copyWith(
                              color: AppColors.primary_90,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Facebook Login Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: ShapeDecoration(
                        color: AppColors.primary_10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: AppColors.primary_90,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: ShapeDecoration(
                              color: Color(0xFF1877F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0C000000),
                                  blurRadius: 10,
                                  offset: Offset(2, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'f',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Lanjutkan dengan Facebook',
                            style: AppTextStyles.body_4_regular.copyWith(
                              color: AppColors.primary_90,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah memiliki akun? ',
                          style: AppTextStyles.body_5_regular.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go(AppRoutes.login);
                          },
                          child: Text(
                            'Masuk',
                            style: AppTextStyles.body_5_bold.copyWith(
                              color: AppColors.primary_90,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;

  const _RegisterField({
    required this.label,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            label,
            style: AppTextStyles.body_3_medium.copyWith(
              color: AppColors.primary_90,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 56,
          decoration: ShapeDecoration(
            color: AppColors.primary_10,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.primary_90),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: AppTextStyles.body_3_regular.copyWith(
                    color: AppColors.default_90,
                  ),
                ),
                style: AppTextStyles.body_3_medium.copyWith(
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
