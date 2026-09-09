import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand / Main Colors (من لوحة الألوان الأساسية)
  static const Color primary = Color(0xFF1B4332);
  static const Color secondary = Color(0xFFD8F3DC);
  static const Color tertiary = Color(0xFFFFB703);
  static const Color neutral = Color(0xFF081C15);

  // Background & Surface
  static const Color background = Color(0xFF081C15);
  static const Color surface = Color(0xFF122820);
  static const Color surfaceVariant = Color(0xFF1B4332);
  static const Color cardBackground = Color(0xFF163228);

  // Borders & Dividers
  static const Color border = Color(0xFF244A3C);
  static const Color divider = Color(0xFF1D3B30);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD8F3DC);
  static const Color textMuted = Color(0xFF6E9B87);
  static const Color textDark = Color(0xFF081C15);

  // Status & Highlights
  static const Color accentYellow = Color(0xFFFFB703);
  static const Color success = Color(0xFF52B788);
  static const Color error = Color(0xFFE63946);

  // Navigation & Icons
  static const Color navBarBackground = Color.fromARGB(255, 17, 52, 39);
  static const Color iconActive = Color(0xFFFFB703);
  static const Color iconInactive = Color(0xFF6E9B87);
}
