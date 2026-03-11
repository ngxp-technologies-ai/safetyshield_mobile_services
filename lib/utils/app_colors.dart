import 'package:flutter/material.dart';

class AppColors {
  /// Core Colors
  static const Color primary = Color(0xFF1F8FB4); // Main - Primary
  static const Color primaryDark = Color(
    0xFF122C34,
  ); // Main - secondary / Main third
  static const Color secondary = Color(0xFF1B6A86); // Secondary (darker blue)
  static const Color light = Color(0xFFF5F6FA); // LT (Light background)

  /// Status Colors
  static const Color success = Color(0xFF2DB468); // Green
  static const Color warning = Color(0xFFF39C12); // Yellow / Orange
  static const Color activeOrange = Color(0xFFE67E22); // Orange
  static const Color error = Color(0xFFE53935); // Red
  static const Color info = Color(0xFF4FC3F7); // Blue (light)

  /// Neutral / Greyscale
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFEEEEEE);
  static const Color black = Color(0xFF000000); // greyscale 1000
  static const Color grey950 = Color(0xFF1A1A1A); // greyscale 950
  static const Color grey900 = Color(0xFF333333); // greyscale 900

  /// Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
