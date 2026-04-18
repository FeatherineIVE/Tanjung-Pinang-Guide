import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/explore_page.dart';
import '../pages/profile_page.dart';
import '../widgets/bottom_navbar.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  DestinationCategory _exploreCategory = DestinationCategory.semua;
  final bool _isLoggedIn = false;

  void _navigateToExplore(DestinationCategory category) {
    setState(() {
      _exploreCategory = category;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onCategoryTap: _navigateToExplore),
      ExplorePage(initialCategory: _exploreCategory),
      const _PlaceholderPage(label: 'AI Guide'),
      const _PlaceholderPage(label: 'Favorit'),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        isLoggedIn: _isLoggedIn,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String label;
  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.construction_rounded,
                    size: 40, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: 16),
              Text('Halaman $label',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text('Segera hadir 🚧',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            ],
          ),
        ),
      ),
    );
  }
}