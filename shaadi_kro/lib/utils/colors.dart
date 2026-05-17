import 'package:flutter/material.dart';

class AppColors {
  // Primary colors inspired by shadiyana.pk
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color gradientStart = Color(0xFFE91E63);
  static const Color gradientEnd = Color(0xFF9C27B0);
  
  // Secondary colors
  static const Color accentGold = Color(0xFFFFD700);
  static const Color softPink = Color(0xFFFCE4EC);
  static const Color lightPurple = Color(0xFFF3E5F5);
  
  // Neutral colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
