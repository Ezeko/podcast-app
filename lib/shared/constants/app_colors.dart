import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - vibrant and modern
  static const Color primary = Color.fromARGB(0, 9, 195, 86);
  static const Color primaryDark = Color.fromARGB(255, 4, 131, 29);
  static const Color primaryLight = Color.fromARGB(255, 9, 242, 87);
  
  // Accent colors
  static const Color accent = Color(0xFFFF6584);
  static const Color accentLight = Color(0xFFFF8FA3);
  
  // Background colors
  static const Color background = Color(0xFF0F0F1E);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color inputBackground = Color(0xFF252541);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C3);
  static const Color textHint = Color(0xFF6E6E82);
  
  // Functional colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFB74D);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5347E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F0F1E), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
