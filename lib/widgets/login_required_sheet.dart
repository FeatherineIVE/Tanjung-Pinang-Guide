import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../screens/auth_screen.dart';

/// Sheet popup "Login Diperlukan" yang dipakai di seluruh app.
/// Semua tombol akan navigate ke AuthScreen.
class LoginRequiredSheet extends StatelessWidget {
  const LoginRequiredSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const LoginRequiredSheet(),
    );
  }

  void _goToAuth(BuildContext context) {
    Navigator.pop(context); // tutup sheet
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.lock_outline_rounded,
                color: Colors.white, size: 30),
          ),
          const SizedBox(height: 20),
          const Text('Login Diperlukan',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          Text(
            'Anda perlu login atau mendaftar terlebih dahulu\nuntuk mengakses fitur ini.',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 28),

          // Daftar Sekarang
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14)),
              child: ElevatedButton(
                onPressed: () => _goToAuth(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Daftar Sekarang',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Masuk
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => _goToAuth(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(
                    color: AppColors.primaryBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Masuk',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),

          // Nanti Saja
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text('Nanti Saja',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}