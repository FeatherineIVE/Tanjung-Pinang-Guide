import 'package:flutter/material.dart';
import '../pages/ai_itinerary_page.dart';
import '../pages/home_page.dart';
import '../pages/home_logged_in_page.dart';
import '../pages/explore_page.dart';
import '../pages/favorite_page.dart';
import '../pages/profile_page.dart';
import '../pages/profile_logged_in_page.dart';
import '../widgets/bottom_navbar.dart';
import '../data/destination_data.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import '../services/user_service.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  DestinationCategory _exploreCategory = DestinationCategory.semua;
  bool _wasLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Fetch bookmarks saat pertama kali masuk jika sudah login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthService>();
      _wasLoggedIn = auth.isLoggedIn;
      if (auth.isLoggedIn) {
        context.read<UserService>().fetchProfileStats(auth.currentUser!.id);
        context.read<FavoriteService>().fetchFavorites(auth.currentUser!.id);
      }
      // Listen perubahan auth state
      auth.addListener(_onAuthChanged);
    });
  }

  @override
  void dispose() {
    context.read<AuthService>().removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    final auth = context.read<AuthService>();
    if (auth.isLoggedIn && !_wasLoggedIn) {
      context.read<UserService>().fetchProfileStats(auth.currentUser!.id);
      context.read<FavoriteService>().fetchFavorites(auth.currentUser!.id);
    } else if (!auth.isLoggedIn && _wasLoggedIn) {
      // Baru logout — clear bookmarks
      context.read<FavoriteService>().clear();
    }
    _wasLoggedIn = auth.isLoggedIn;
  }

  void _navigateToExplore(DestinationCategory category) {
    setState(() {
      _exploreCategory = category;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isLoggedIn = auth.isLoggedIn;

    final pages = [
      isLoggedIn
          ? HomeLoggedInPage(onCategoryTap: _navigateToExplore)
          : HomePage(onCategoryTap: _navigateToExplore),
      ExplorePage(initialCategory: _exploreCategory),
      const AIItineraryPage(),
      const FavoritePage(),
      isLoggedIn
          ? const ProfileLoggedInPage()
          : const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        isLoggedIn: isLoggedIn,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 4 && isLoggedIn) {
            final user = auth.currentUser;
            if (user != null) {
              context.read<UserService>().fetchProfileStats(user.id);
            }
          }
        },
      ),
    );
  }
}