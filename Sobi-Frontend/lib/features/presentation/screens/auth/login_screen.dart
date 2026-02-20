import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sobi/features/presentation/style/colors.dart';
import 'package:sobi/features/presentation/style/typography.dart';
import '../../router/app_routes.dart';
import '../../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get isFormValid =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateState);
    passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    emailController.removeListener(_updateState);
    passwordController.removeListener(_updateState);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!isFormValid) {
      Fluttertoast.showToast(msg: 'Email dan password harus diisi');
      return;
    }
    await authProvider.signIn(emailController.text, passwordController.text);
    // Ambil error dari backend jika ada, bukan dari DioException
    String errorMsg = '';
    if (authProvider.error != null) {
      // Coba ambil pesan error dari backend jika formatnya Map
      if (authProvider.error is Map<String, dynamic>) {
        errorMsg =
            (authProvider.error as Map<String, dynamic>)['error']?.toString() ??
            '';
      } else {
        errorMsg = authProvider.error.toString();
        // Coba parse jika errorMsg adalah JSON string
        try {
          final decoded =
              errorMsg.startsWith('{') ? jsonDecode(errorMsg) : null;
          if (decoded != null && decoded is Map && decoded['error'] != null) {
            errorMsg = decoded['error'].toString();
          }
        } catch (_) {}
      }
    }
    if (authProvider.token != null && authProvider.user != null) {
      Fluttertoast.showToast(msg: 'Login berhasil');
      context.go(AppRoutes.navbar);
    } else {
      Fluttertoast.showToast(
        msg: errorMsg.isNotEmpty ? errorMsg : 'Login gagal',
      );
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
                    const SizedBox(height: 60),
                    Text(
                      'Masuk ke akun\nAnda',
                      style: AppTextStyles.heading_3_bold.copyWith(
                        color: AppColors.default_10,
                      ),
                    ),
                    Text(
                      'Masukkan alamat email dan kata sandi Anda untuk masuk.',
                      style: AppTextStyles.body_4_regular.copyWith(
                        color: AppColors.default_10,
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Email Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Email',
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
                            color: const Color(0xFFD8CDE4),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Color(0xFF3F2C53),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: AppTextStyles.body_3_regular
                                      .copyWith(color: AppColors.default_90),
                                ),
                                style: AppTextStyles.body_3_medium.copyWith(
                                  color: AppColors.primary_90,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Kata Sandi',
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
                            color: const Color(0xFFD8CDE4),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Color(0xFF3F2C53),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Kata sandi',
                                  hintStyle: AppTextStyles.body_3_regular
                                      .copyWith(color: AppColors.default_90),
                                ),
                                style: AppTextStyles.body_3_medium.copyWith(
                                  color: AppColors.primary_90,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Lupa kata sandi?',
                        style: AppTextStyles.body_5_bold.copyWith(
                          color: AppColors.primary_90,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Login Button
                    GestureDetector(
                      onTap: isFormValid ? _login : null,
                      child: Container(
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
                            'Masuk',
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
                    const SizedBox(height: 60),
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppTextStyles.body_5_regular.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go(AppRoutes.register);
                          },
                          child: Text(
                            'Daftar',
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
