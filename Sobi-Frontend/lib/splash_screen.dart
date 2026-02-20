import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/presentation/router/app_routes.dart';
import 'dart:async';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // mulai animasi lingkaran
    _circleController.forward();

    // delay untuk logo muncul setelah lingkaran mengecil
    Future.delayed(const Duration(milliseconds: 1000), () {
      _logoController.forward();
    });

    // delay pindah ke home
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // LINGKARAN TETAP DI CENTER, FADE OUT + MENGECIL
          Center(
            child: AnimatedBuilder(
              animation: _circleController,
              builder: (_, child) {
                final size = 200.0; // ukuran awal lingkaran
                return Opacity(
                  opacity: 1 - _circleController.value, // fade out
                  child: Transform.scale(
                    scale: 1 - _circleController.value, // mengecil
                    child: Container(
                      width: size,
                      height: size,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7E57A6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // LOGO SCALE IN
          ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _logoController,
                curve: Curves.easeOutBack,
              ),
            ),
            child: Image.asset('assets/logo/Logo.png', width: 120, height: 120),
          ),
        ],
      ),
    );
  }
}
