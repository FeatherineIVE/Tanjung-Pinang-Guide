import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../shell/main_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _tabAnimationController;

  @override
  void initState() {
    super.initState();
    _tabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabAnimationController.dispose();
    super.dispose();
  }

  void _switchTab(bool isLogin) => setState(() => _isLogin = isLogin);

  /// Navigate ke MainShell (homepage) setelah login/daftar/tamu
  void _goToMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false, // hapus semua route sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabToggle(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative circles
          Positioned(
            top: -30, left: -30,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: -10, right: -20,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.05),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.3), width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo_white.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.explore_rounded, color: Colors.white, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tanjung Pinang\nGuide',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _switchTab(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: _isLogin ? AppColors.buttonGradient : null,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text('Masuk',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isLogin ? AppColors.white : AppColors.textGrey)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _switchTab(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: !_isLogin ? AppColors.buttonGradient : null,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text('Daftar',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: !_isLogin ? AppColors.white : AppColors.textGrey)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      key: const ValueKey('login'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(label: 'Email', hintText: 'Masukkan email', prefixIcon: Icons.email_outlined),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            hintText: 'Masukkan password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Lupa Password?',
                  style: TextStyle(fontSize: 14, color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 16),
          _buildPrimaryButton('Masuk'),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildGoogleButton(),
          const SizedBox(height: 12),
          _buildGuestButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Padding(
      key: const ValueKey('register'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(label: 'Nama Lengkap', hintText: 'Masukkan nama lengkap', prefixIcon: Icons.person_outline),
          const SizedBox(height: 16),
          CustomTextField(label: 'Email', hintText: 'Masukkan email', prefixIcon: Icons.email_outlined),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            hintText: 'Masukkan password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Konfirmasi Password',
            hintText: 'Ulangi password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            onTogglePassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
          const SizedBox(height: 24),
          _buildPrimaryButton('Daftar Sekarang'),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildGoogleButton(),
          const SizedBox(height: 12),
          _buildGuestButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _goToMain, // ← navigate ke MainShell
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.white)),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.greyBorder, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('atau', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
        ),
        Expanded(child: Divider(color: AppColors.greyBorder, thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.greyBorder, width: 1),
      ),
      child: TextButton(
        onPressed: _goToMain, // ← navigate ke MainShell
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24, height: 24,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://www.google.com/favicon.ico'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Lanjutkan dengan Google',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.greyBorder, width: 1),
      ),
      child: TextButton(
        onPressed: _goToMain, // ← tamu juga masuk ke MainShell
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, color: AppColors.primaryBlue, size: 22),
            const SizedBox(width: 12),
            const Text('Lanjutkan sebagai Tamu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}