import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanjung Pinang Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A9BD7)),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

// ── MainShell: mengelola bottom navbar & perpindahan halaman ──────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Daftar semua halaman sesuai urutan bottom nav
  static const List<Widget> _pages = [
    HomePage(),                          // index 0 - Beranda
    _PlaceholderPage(label: 'Jelajahi'), // index 1
    _PlaceholderPage(label: 'AI Guide'), // index 2
    _PlaceholderPage(label: 'Favorit'),  // index 3
    ProfilePage(),                       // index 4 - Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack agar state halaman tidak hilang saat ganti tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// ── Bottom Navigation Bar ─────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.currentIndex, required this.onTap});

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.home_rounded, 'label': 'Beranda'},
    {'icon': Icons.explore_rounded, 'label': 'Jelajahi'},
    {'icon': Icons.smart_toy_rounded, 'label': 'AI Guide'},
    {'icon': Icons.favorite_rounded, 'label': 'Favorit'},
    {'icon': Icons.person_rounded, 'label': 'Profil'},
  ];

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
            children: List.generate(_items.length, (index) {
              final isActive = index == currentIndex;
              final icon = _items[index]['icon'] as IconData;
              final label = _items[index]['label'] as String;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isActive
                            ? const Color(0xFF1A9BD7)
                            : Colors.grey[400],
                        size: isActive ? 26 : 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive
                              ? const Color(0xFF1A9BD7)
                              : Colors.grey[400],
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
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

// ── Placeholder untuk halaman yang belum dibuat ───────────────────────────────
class _PlaceholderPage extends StatelessWidget {
  final String label;
  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9BD7).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.construction_rounded,
                    size: 40, color: Color(0xFF1A9BD7)),
              ),
              const SizedBox(height: 16),
              Text(
                'Halaman $label',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2A3A)),
              ),
              const SizedBox(height: 8),
              Text(
                'Segera hadir 🚧',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}