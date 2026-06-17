import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

// ── Services ──────────────────────────────────────────────────────────────────
import 'services/auth_service.dart';
import 'services/destination_service.dart';
import 'services/user_service.dart';
import 'services/favorite_service.dart';
import 'services/review_service.dart';
import 'services/itinerary_service.dart';
import 'services/ai_service.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase (diperlukan oleh firebase_auth dan google_sign_in)
  await Firebase.initializeApp();
  // Inisialisasi Notifikasi Lokal
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth — dibuat pertama agar provider lain bisa bergantung
        ChangeNotifierProvider(create: (_) => AuthService()..init()),

        // Data services
        ChangeNotifierProvider(create: (_) => DestinationService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => FavoriteService()),
        ChangeNotifierProvider(create: (_) => ReviewService()),
        ChangeNotifierProvider(create: (_) => ItineraryService()),
        ChangeNotifierProvider(create: (_) => AiService()),
      ],
      child: MaterialApp(
        title: 'Tanjung Pinang Guide',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}