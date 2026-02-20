import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sobi/features/presentation/style/colors.dart';
import 'package:sobi/features/presentation/style/typography.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../router/app_routes.dart';
import '../../provider/auth_provider.dart';

class VerifScreen extends StatefulWidget {
  final String email;
  const VerifScreen({super.key, required this.email});

  @override
  State<VerifScreen> createState() => _VerifScreenState();
}

class _VerifScreenState extends State<VerifScreen> {
  final TextEditingController otpController = TextEditingController();
  final List<TextEditingController> otpFields = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int timerSeconds = 300;
  String? email;
  late final AuthProvider authProvider;
  late final PageController pageController;
  bool isVerifying = false;

  bool get isOtpValid => otpFields.every((c) => c.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      email = widget.email;
    });
    for (final c in otpFields) {
      c.addListener(_updateState);
    }
    _startTimer();
  }

  void _updateState() {
    setState(() {});
  }

  void _startTimer() {
    timerSeconds = 300;
    Future.doWhile(() async {
      if (timerSeconds > 0) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) setState(() => timerSeconds--);
        return true;
      }
      return false;
    });
  }

  String get timerText {
    final min = (timerSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (timerSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  void _onOtpChanged(int idx, String val) {
    if (val.length == 1 && idx < 3) {
      FocusScope.of(context).nextFocus();
    }
    if (val.isEmpty && idx > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = otpFields.map((c) => c.text).join();
    if (otp.length != 4) {
      Fluttertoast.showToast(msg: 'Kode OTP harus 4 digit');
      return;
    }
    setState(() => isVerifying = true);
    try {
      await authProvider.verifyOtp(email ?? '', otp);
      if (authProvider.error == null) {
        Fluttertoast.showToast(msg: 'Verifikasi berhasil');
        _showSuccessDialog();
      } else {
        Fluttertoast.showToast(msg: authProvider.error ?? 'Verifikasi gagal');
      }
    } finally {
      setState(() => isVerifying = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => isVerifying = true);
    try {
      await authProvider.verifyOtp(email ?? '', '');
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP telah dikirim ulang')),
      );
    } finally {
      setState(() => isVerifying = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 300,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF583D74),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selamat verifikasi akun mu berhasil!',
                      style: TextStyle(fontSize: 14, color: Color(0xFF583D74)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.go(AppRoutes.login);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7E57A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    for (final c in otpFields) {
      c.removeListener(_updateState);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // pastikan ini true
      body: Stack(
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          Text(
                            'Verifikasi',
                            style: AppTextStyles.heading_3_bold.copyWith(
                              color: AppColors.default_10,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Masukkan kode yang kami kirimkan melalui email kepada Anda.',
                            style: AppTextStyles.body_4_regular.copyWith(
                              color: AppColors.default_30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    timerText,
                                    style: AppTextStyles.heading_5_bold
                                        .copyWith(color: AppColors.primary_90),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (idx) {
                                      return Container(
                                        width: 56,
                                        height: 56,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD8CDE4),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Color(0xFF3F2C53),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: otpFields[idx],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            maxLength: 1,
                                            style: AppTextStyles.heading_3_bold
                                                .copyWith(
                                                  color: AppColors.primary_90,
                                                ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              counterText: '',
                                            ),
                                            onChanged:
                                                (val) =>
                                                    _onOtpChanged(idx, val),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          isVerifying || !isOtpValid
                                              ? null
                                              : _verifyOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            isVerifying || !isOtpValid
                                                ? AppColors.default_70
                                                : AppColors.primary_90,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      child: Text(
                                        'Daftar',
                                        style: AppTextStyles.body_3_bold
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer dihapus, agar bagian bawah tidak ikut naik saat keyboard muncul
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Saya tidak menerima kode. ',
                                style: AppTextStyles.body_4_regular.copyWith(
                                  color: AppColors.primary_90,
                                ),
                              ),
                              GestureDetector(
                                onTap: isVerifying ? null : _resendOtp,
                                child: Text(
                                  'Kirim ulang',
                                  style: AppTextStyles.body_4_bold.copyWith(
                                    color: AppColors.primary_90,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
