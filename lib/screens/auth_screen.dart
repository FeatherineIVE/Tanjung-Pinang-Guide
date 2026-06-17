import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/app_toast.dart';
import '../services/auth_service.dart';
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
  bool _isLoading = false;

  late AnimationController _tabAnimationController;

  // ── Controllers ────────────────────────────────────────────────────────
  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();

  final _regNamaCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regConfirmCtrl = TextEditingController();

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
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regNamaCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    _regConfirmCtrl.dispose();
    super.dispose();
  }

  void _switchTab(bool isLogin) => setState(() => _isLogin = isLogin);

  // ── Lupa Password Sheet ────────────────────────────────────────────────
  void _showForgotPasswordSheet(BuildContext ctx) {
    final emailCtrl = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Icon
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.lock_reset_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    const Text('Reset Password',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    Text(
                      'Masukkan email terdaftar dan password baru kamu',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),

                    // Email
                    CustomTextField(
                      label: 'Email Terdaftar',
                      hintText: 'Masukkan email',
                      prefixIcon: Icons.email_outlined,
                      controller: emailCtrl,
                    ),


                    // Tombol Reset
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setSheetState(() => isLoading = true);
                                  setSheetState(() => isLoading = true);
                                  final auth = context.read<AuthService>();
                                  final error = await auth.forgotPassword(emailCtrl.text);
                                  setSheetState(() => isLoading = false);
                                  
                                  if (ctx.mounted) {
                                    if (error != null) {
                                      AppToast.error(ctx, error);
                                    } else {
                                      Navigator.pop(context);
                                      AppToast.success(ctx, 'Link reset password telah dikirim ke email Anda. Silakan cek juga folder spam atau junk jika tidak masuk.');
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26)),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('Reset Password',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Batal
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Navigate ke MainShell ──────────────────────────────────────────────
  void _goToMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }



  // ── Handle Login ──────────────────────────────────────────────────────
  void _handleLogin() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    final error = await auth.login(
      email:    _loginEmailCtrl.text,
      password: _loginPassCtrl.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (error != null) {
      AppToast.error(context, error);
    } else {
      AppToast.success(context, 'Selamat datang, ${auth.userName}!');
      await Future.delayed(const Duration(milliseconds: 600));
      _goToMain();
    }
  }

  // ── Handle Google Login ───────────────────────────────────────────────
  void _handleGoogleLogin({required bool isRegister}) async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    final error = await auth.loginWithGoogle(isRegister: isRegister);
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (error != null) {
      if (error != 'Login Google dibatalkan') {
        AppToast.error(context, error);
      }
    } else {
      AppToast.success(context, isRegister ? 'Pendaftaran dengan Google berhasil!' : 'Selamat datang, ${auth.userName}!');
      await Future.delayed(const Duration(milliseconds: 600));
      _goToMain();
    }
  }

  // ── Handle Register ───────────────────────────────────────────────────
  void _handleRegister() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    // Client-side validasi password cocok
    if (_regPassCtrl.text != _regConfirmCtrl.text) {
      setState(() => _isLoading = false);
      AppToast.error(context, 'Password tidak cocok');
      return;
    }
    final error = await auth.register(
      nama:     _regNamaCtrl.text,
      email:    _regEmailCtrl.text,
      password: _regPassCtrl.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (error != null) {
      AppToast.error(context, error);
    } else {
      AppToast.success(context, 'Pendaftaran berhasil! Silakan login');
      // Setelah register, pindah ke tab login
      setState(() => _isLogin = true);
    }
  }

  // ── Handle Guest ──────────────────────────────────────────────────────
  void _handleGuest() {
    final auth = context.read<AuthService>();
    auth.loginAsGuest();
    AppToast.info(context, 'Masuk sebagai Tamu');
    Future.delayed(const Duration(milliseconds: 500), _goToMain);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
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
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBlue,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
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
          CustomTextField(
            label: 'Email',
            hintText: 'Masukkan email',
            prefixIcon: Icons.email_outlined,
            controller: _loginEmailCtrl,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            hintText: 'Masukkan password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
            controller: _loginPassCtrl,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordSheet(context),
              child: const Text('Lupa Password?',
                  style: TextStyle(fontSize: 14, color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 16),
          _buildPrimaryButton('Masuk', onPressed: _handleLogin),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildGoogleButton(isRegister: false),
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
          CustomTextField(
            label: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkap',
            prefixIcon: Icons.person_outline,
            controller: _regNamaCtrl,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email',
            hintText: 'Masukkan email',
            prefixIcon: Icons.email_outlined,
            controller: _regEmailCtrl,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            hintText: 'Masukkan password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
            controller: _regPassCtrl,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Konfirmasi Password',
            hintText: 'Ulangi password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            onTogglePassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            controller: _regConfirmCtrl,
          ),
          const SizedBox(height: 24),
          _buildPrimaryButton('Daftar Sekarang', onPressed: _handleRegister),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildGoogleButton(isRegister: true),
          const SizedBox(height: 12),
          _buildGuestButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text, {required VoidCallback onPressed}) {
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
        onPressed: _isLoading ? null : onPressed,
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
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.greyBorder, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('atau', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
        ),
        Expanded(child: Divider(color: AppColors.greyBorder, thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleButton({required bool isRegister}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.greyBorder, width: 1),
      ),
      child: TextButton(
        onPressed: _isLoading ? null : () => _handleGoogleLogin(isRegister: isRegister),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google_logo.png', height: 24, errorBuilder: (c, e, s) => const Icon(Icons.g_mobiledata, color: Colors.red, size: 32)),
            const SizedBox(width: 12),
            Text(isRegister ? 'Daftar dengan Google' : 'Masuk dengan Google',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
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
        onPressed: _isLoading ? null : _handleGuest,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, color: AppColors.primaryBlue, size: 22),
            SizedBox(width: 12),
            Text('Lanjutkan sebagai Tamu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}