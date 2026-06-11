import 'package:flutter/material.dart';

/// App color system containing premium color palettes for light and dark modes.
class AppColors {
  AppColors._();

  // Primary Branding
  static const Color primary = Color(0xFF6366F1); // Modern Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color accent = Color(0xFFEC4899); // Pink Accent

  // Neutrals (Light Mode)
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Neutrals (Dark Mode)
  static const Color bgDark = Color(0xFF0F172A); // Deep Slate
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF334155);

  // Status/Semantic Colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF0EA5E9); // Sky Blue

  // Fallback Event Colors
  static const List<Color> eventColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF0EA5E9), // Sky Blue
    Color(0xFF8B5CF6), // Purple
  ];

  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? bgDark : bgLight;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight;
  }

  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? borderDark : borderLight;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;
  }

  static Color getTextMuted(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textMutedDark : textMutedLight;
  }
}
