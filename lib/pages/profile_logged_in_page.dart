import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
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
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    if (user == null) return const SizedBox.shrink();
    // Ambil inisial dari nama
    final initials = user.nama
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
    final isGoogleUser = user.isGoogleUser;

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
                      // Badge Google
                      if (isGoogleUser) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                'https://www.google.com/favicon.ico',
                                width: 14,
                                height: 14,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.white,
                                    size: 14),
                              ),
                              const SizedBox(width: 6),
                              const Text('Login via Google',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
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
                            onTap: () => _showEditProfileSheet(context, auth)),
                        // Sembunyikan Ubah Password untuk user Google
                        if (!isGoogleUser) ...[
                          const Divider(height: 1, indent: 56),
                          _InfoMenuItem(
                              icon: Icons.lock_outline_rounded,
                              label: 'Ubah Password',
                              onTap: () => _showChangePasswordSheet(
                                  context, auth)),
                        ],
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
            onPressed: () async {
              Navigator.pop(ctx);
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              }
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

  // ── Edit Profile Sheet ────────────────────────────────────────────
  void _showEditProfileSheet(BuildContext ctx, AuthService auth) {
    final user = auth.currentUser!;
    final namaCtrl    = TextEditingController(text: user.nama);
    final teleponCtrl = TextEditingController(text: user.telepon ?? '');
    final bioCtrl     = TextEditingController(text: user.bio ?? '');

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
                    Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.person_outline_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    const Text('Edit Profil',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Nama Lengkap',
                      hintText: 'Masukkan nama',
                      prefixIcon: Icons.person_outline,
                      controller: namaCtrl,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Nomor Telepon',
                      hintText: 'Masukkan nomor telepon',
                      prefixIcon: Icons.phone_outlined,
                      controller: teleponCtrl,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Bio',
                      hintText: 'Ceritakan tentang dirimu',
                      prefixIcon: Icons.info_outline,
                      controller: bioCtrl,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            final userSvc = ctx.read<UserService>();
                            final error = await userSvc.updateProfile(
                              nama:    namaCtrl.text,
                              bio:     bioCtrl.text,
                              telepon: teleponCtrl.text,
                            );
                            if (!sheetCtx.mounted) return;
                            if (error != null) {
                              AppToast.error(ctx, error);
                            } else {
                              // Sync updated name ke AuthService local state
                              if (userSvc.profile != null) {
                                auth.updateLocalUser(userSvc.profile!);
                              }
                              Navigator.pop(sheetCtx);
                              AppToast.success(ctx, 'Profil berhasil diperbarui ✅');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26)),
                          ),
                          child: const Text('Simpan Perubahan',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(sheetCtx),
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

  // ── Ubah Password Sheet ────────────────────────────────────────────────
  void _showChangePasswordSheet(BuildContext ctx, AuthService auth) {
    // Password change tidak tersedia via backend saat ini
    // Tampilkan informasi
    AppToast.info(ctx, 'Fitur ubah password sedang dalam pengembangan');
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
