import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import '../core/network/token_storage.dart';
import '../shell/main_shell.dart';
import 'onboarding_screen.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    final auth = context.read<AuthService>();

    // Tunggu splash 2.5 detik DAN AuthService.init() selesai
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2500)),
      Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return auth.isInitializing;
      }),
    ]);

    if (!mounted) return;

    Widget destination;

    if (auth.isLoggedIn) {
      // User masih punya sesi valid → langsung masuk
      destination = const MainShell();
    } else {
      // Cek apakah user pernah login sebelumnya di device ini
      final everLoggedIn = await TokenStorage.hasEverLoggedIn();
      if (everLoggedIn) {
        // Pernah login tapi token habis → langsung ke halaman login (skip onboarding)
        destination = const AuthScreen();
      } else {
        // Belum pernah login sama sekali → tampilkan onboarding
        destination = const OnboardingScreen();
      }
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.white,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Blue Logo
                Image.asset(
                  'assets/images/logo_blue.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.explore_rounded,
                    size: 80,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tanjung Pinang\nGuide',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlueDark,
                    height: 1.2,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
