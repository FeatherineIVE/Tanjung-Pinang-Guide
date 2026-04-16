import 'package:flutter/material.dart';

class AppColors {
  // Primary blues
  static const Color primaryBlue = Color(0xFF00AEEF);
  static const Color primaryBlueDark = Color(0xFF0077C2);
  static const Color primaryBlueLight = Color(0xFF4FC3F7);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryBlue, primaryBlueDark],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, primaryBlueDark],
  );

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyBorder = Color(0xFFE0E0E0);
  static const Color textDark = Color(0xFF333333);
  static const Color textGrey = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Background
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
}
