import 'package:flutter/material.dart';

// ── Definisi item bottom nav ──────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  final bool requiresLogin; // true = tampilkan popup jika belum login

  const _NavItem({
    required this.icon,
    required this.label,
    this.requiresLogin = false,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(icon: Icons.home_rounded, label: 'Beranda'),
  _NavItem(icon: Icons.explore_rounded, label: 'Jelajahi'),
  _NavItem(icon: Icons.smart_toy_rounded, label: 'AI Guide', requiresLogin: true),
  _NavItem(icon: Icons.favorite_rounded, label: 'Favorit', requiresLogin: true),
  _NavItem(icon: Icons.person_rounded, label: 'Profil'),
];

// ── BottomNavBar widget ───────────────────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isLoggedIn;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isLoggedIn = false, // default: tamu / belum login
  });

  void _handleTap(BuildContext context, int index) {
    final item = _navItems[index];

    // Jika tab butuh login dan user belum login → tampilkan popup
    if (item.requiresLogin && !isLoggedIn) {
      _showLoginRequired(context);
      return;
    }

    onTap(index);
  }

  void _showLoginRequired(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _LoginRequiredSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = index == currentIndex;
              // Tab yang butuh login tapi belum login → tampil abu-abu + kunci kecil
              final isLocked = item.requiresLogin && !isLoggedIn;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _handleTap(context, index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            item.icon,
                            color: isActive
                                ? const Color(0xFF1A9BD7)
                                : Colors.grey[400],
                            size: isActive ? 26 : 24,
                          ),
                          // Ikon gembok kecil di sudut kanan atas jika locked
                          if (isLocked)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A9BD7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  size: 7,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive
                              ? const Color(0xFF1A9BD7)
                              : Colors.grey[400],
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Modal "Login Diperlukan" ──────────────────────────────────────────────────
// Diletakkan di sini agar bottom_navbar.dart berdiri sendiri tanpa dependensi luar
class _LoginRequiredSheet extends StatelessWidget {
  const _LoginRequiredSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon gembok
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A9BD7), Color(0xFF0D7AB5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: Colors.white, size: 30),
          ),
          const SizedBox(height: 20),

          const Text(
            'Login Diperlukan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2A3A),
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'Anda perlu login atau mendaftar terlebih dahulu\nuntuk mengakses menu destinasi dan fitur lainnya.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Daftar Sekarang
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigator.push ke RegisterPage
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A9BD7),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Daftar Sekarang',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),

          // Masuk
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigator.push ke LoginPage
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1A9BD7),
                side: const BorderSide(color: Color(0xFF1A9BD7), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Masuk',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),

          // Nanti Saja
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Nanti Saja',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}