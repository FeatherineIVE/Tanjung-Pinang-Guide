import 'package:flutter/material.dart';
import '../screens/auth_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _goToAuth(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD),
      body: CustomScrollView(
        slivers: [
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
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4), width: 2),
                        ),
                        child: const Icon(Icons.person_rounded,
                            size: 44, color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Halo, Penjelajah!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Login untuk pengalaman yang lebih personal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13),
                      ),
                      const SizedBox(height: 28),

                      // ── Masuk ke Akun → AuthScreen ──────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _goToAuth(context),
                          icon: const Icon(Icons.login_rounded, size: 20),
                          label: const Text(
                            'Masuk ke Akun',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF00AEEF),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Daftar Akun Baru → AuthScreen ───────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () => _goToAuth(context),
                          icon: const Icon(Icons.person_add_rounded, size: 20),
                          label: const Text(
                            'Daftar Akun Baru',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.white, width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Keuntungan Bergabung ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keuntungan Bergabung',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2A3A)),
                    ),
                    SizedBox(height: 16),
                    _BenefitItem(
                      icon: Icons.star_rounded,
                      color: Color(0xFFFFB300),
                      text: 'Rekomendasi AI yang dipersonalisasi',
                    ),
                    SizedBox(height: 12),
                    _BenefitItem(
                      icon: Icons.favorite_rounded,
                      color: Color(0xFFEF5350),
                      text: 'Simpan destinasi favorit',
                    ),
                    SizedBox(height: 12),
                    _BenefitItem(
                      icon: Icons.emoji_events_rounded,
                      color: Color(0xFF00AEEF),
                      text: 'Kumpulkan poin & raih level',
                    ),
                    SizedBox(height: 12),
                    _BenefitItem(
                      icon: Icons.volunteer_activism_rounded,
                      color: Color(0xFF66BB6A),
                      text: 'Dukung pariwisata berkeadilan',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Informasi Umum ───────────────────────────────────────────────
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

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _BenefitItem(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3A4A5A),
                  fontWeight: FontWeight.w500)),
        ),
      ],
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
        leading: const Icon(Icons.info_outline_rounded,
            color: Color(0xFF00AEEF), size: 22),
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