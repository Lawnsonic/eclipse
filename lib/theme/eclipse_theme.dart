import 'package:flutter/cupertino.dart';

class EclipseTheme {
  // Backgrounds
  static const Color background = Color(0xFF070B14);
  static const Color surface = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFF1E293B);
  static const Color cardGlass = Color(0xCC111C35);
  static const Color cardBorder = Color(0x2694A3B8);

  // Accents
  static const Color solarGold = Color(0xFFF59E0B);
  static const Color solarAmber = Color(0xFFD97706);
  static const Color callGreen = Color(0xFF10B981);
  static const Color cyberCyan = Color(0xFF06B6D4);
  static const Color neonPink = Color(0xFFEC4899);
  static const Color astralPurple = Color(0xFF8B5CF6);

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Box Decorations
  static BoxDecoration glassCardDecoration({Color? borderColor, double radius = 18}) {
    return BoxDecoration(
      color: cardGlass,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? cardBorder,
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: CupertinoColors.black.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration glowCard({required Color glowColor, double radius = 18}) {
    return BoxDecoration(
      color: cardGlass,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: glowColor.withValues(alpha: 0.4),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: glowColor.withValues(alpha: 0.2),
          blurRadius: 20,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
