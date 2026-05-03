import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '../screens/auth_screen.dart';
import '../widgets/app_toast.dart';
import '../widgets/custom_text_field.dart';
import '../utils/app_colors.dart';

/// Halaman Profil untuk user yang SUDAH LOGIN.
/// Menampilkan data user, pengaturan akun, aktivitas, dan info umum.
class ProfileLoggedInPage extends StatelessWidget {
  const ProfileLoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final user = auth.currentUser!;
    // Ambil inisial dari nama
    final initials = user.nama
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD),
      body: CustomScrollView(
        slivers: [
          // ── Header Profil ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00AEEF), Color(0xFF0077C2)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  child: Column(
                    children: [
                      const Text(
                        'Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Avatar inisial
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 2),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.nama,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Pengaturan Akun ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Akun',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2A3A)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _InfoMenuItem(
                            icon: Icons.person_outline_rounded,
                            label: 'Edit Profil',
                            onTap: () {}),
                        const Divider(height: 1, indent: 56),
                        _InfoMenuItem(
                            icon: Icons.lock_outline_rounded,
                            label: 'Ubah Password',
                            onTap: () => _showChangePasswordSheet(
                                context, auth)),
                        const Divider(height: 1, indent: 56),
                        _InfoMenuItem(
                            icon: Icons.notifications_none_rounded,
                            label: 'Notifikasi',
                            onTap: () {},
                            isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Aktivitas ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aktivitas Kamu',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2A3A)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _StatItem(
                          icon: Icons.favorite_rounded,
                          color: const Color(0xFFEF5350),
                          value: '12',
                          label: 'Favorit',
                        ),
                        const SizedBox(width: 16),
                        _StatItem(
                          icon: Icons.place_rounded,
                          color: const Color(0xFF00AEEF),
                          value: '5',
                          label: 'Dikunjungi',
                        ),
                        const SizedBox(width: 16),
                        _StatItem(
                          icon: Icons.star_rounded,
                          color: const Color(0xFFFFB300),
                          value: '230',
                          label: 'Poin',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Informasi Umum ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Umum',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2A3A)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _InfoMenuItem(
                            icon: Icons.info_outline_rounded,
                            label: 'Tentang Aplikasi',
                            onTap: () {}),
                        const Divider(height: 1, indent: 56),
                        _InfoMenuItem(
                            icon: Icons.language_rounded,
                            label: 'Bahasa',
                            onTap: () {}),
                        const Divider(height: 1, indent: 56),
                        _InfoMenuItem(
                            icon: Icons.privacy_tip_outlined,
                            label: 'Kebijakan Privasi',
                            onTap: () {}),
                        const Divider(height: 1, indent: 56),
                        _InfoMenuItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Bantuan & FAQ',
                            onTap: () {},
                            isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Tombol Keluar ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context, auth),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text('Keluar',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(
                        color: Color(0xFFE53935), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  // ── Logout ──────────────────────────────────────────────────────────────
  void _logout(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar Akun',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: const Text('Yakin ingin keluar dari akun ini?',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(
                    color: Color(0xFF888888), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Keluar',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Ubah Password Sheet ────────────────────────────────────────────────
  void _showChangePasswordSheet(BuildContext ctx, AuthService auth) {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
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
                      child: const Icon(Icons.lock_outline_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    const Text('Ubah Password',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    Text(
                      'Masukkan password lama dan password baru kamu',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),

                    // Password lama
                    CustomTextField(
                      label: 'Password Lama',
                      hintText: 'Masukkan password saat ini',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: obscureOld,
                      onTogglePassword: () =>
                          setSheetState(() => obscureOld = !obscureOld),
                      controller: oldPassCtrl,
                    ),
                    const SizedBox(height: 16),

                    // Password baru
                    CustomTextField(
                      label: 'Password Baru',
                      hintText: 'Minimal 6 karakter',
                      prefixIcon: Icons.lock_reset_rounded,
                      isPassword: true,
                      obscureText: obscureNew,
                      onTogglePassword: () =>
                          setSheetState(() => obscureNew = !obscureNew),
                      controller: newPassCtrl,
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi password
                    CustomTextField(
                      label: 'Konfirmasi Password Baru',
                      hintText: 'Ulangi password baru',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: obscureConfirm,
                      onTogglePassword: () =>
                          setSheetState(() => obscureConfirm = !obscureConfirm),
                      controller: confirmPassCtrl,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Ubah
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
                                  await Future.delayed(
                                      const Duration(milliseconds: 600));

                                  final error = auth.changePassword(
                                    oldPassCtrl.text,
                                    newPassCtrl.text,
                                    confirmPassCtrl.text,
                                  );

                                  setSheetState(() => isLoading = false);

                                  if (error != null) {
                                    if (ctx.mounted) {
                                      AppToast.error(ctx, error);
                                    }
                                  } else {
                                    if (ctx.mounted) {
                                      Navigator.pop(context);
                                      AppToast.success(ctx,
                                          'Password berhasil diubah! ✅');
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
                              : const Text('Ubah Password',
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
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _InfoMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const _InfoMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(14))
          : BorderRadius.zero,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00AEEF), size: 22),
        title: Text(label,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A2A3A),
                fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: Colors.grey, size: 20),
        onTap: onTap,
        dense: true,
      ),
    );
  }
}
