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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    final auth = context.read<AuthService>();

    // Tunggu minimal 1.5 detik agar loading screen (logo + teks) sempat terbaca
    // sekaligus menunggu AuthService selesai inisialisasi
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      Future.doWhile(() async {
        if (!auth.isInitializing) return false;
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.white,
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
    );
  }
}
