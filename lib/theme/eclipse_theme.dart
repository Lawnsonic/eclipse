import 'package:flutter/cupertino.dart';

/// Luxury Monochrome Design System (Noir & Titanium / Crisp White).
/// Based on Apple HIG and luxury minimalist interface principles:
/// - Avoids rainbow color chaos in favor of sophisticated grayscale hierarchy.
/// - Uses layered titanium depths (0xFF000000, 0xFF121212, 0xFF1C1C1E, 0xFF2C2C2E).
/// - Crisp typography hierarchy (Primary: #FFFFFF, Secondary: #A1A1A6, Muted: #636366).
/// - High-contrast subtle borders and frosted acrylic finishes.
class EclipseTheme {
  // Backgrounds
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceElevated = Color(0xFF1C1C1E);
  static const Color surfaceHighlight = Color(0xFF2C2C2E);

  // Cards & Frosted Glass
  static const Color cardGlass = Color(0xF0141416);
  static const Color cardBorder = Color(0x24FFFFFF); // 14% white border
  static const Color cardBorderSubtle = Color(0x14FFFFFF); // 8% white border
  static const Color cardBorderHighlight = Color(0x59FFFFFF); // 35% white border

  // Monochrome Accents
  static const Color white = Color(0xFFFFFFFF);
  static const Color platinum = Color(0xFFE5E5EA);
  static const Color silver = Color(0xFFD1D1D6);
  static const Color charcoal = Color(0xFF242426);
  static const Color graphite = Color(0xFF1C1C1E);

  // Typography Tokens
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1A6);
  static const Color textMuted = Color(0xFF636366);

  // Glassmorphic Card Decorations
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
          color: CupertinoColors.black.withValues(alpha: 0.6),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration sleekPillDecoration({bool isActive = false, double radius = 12}) {
    return BoxDecoration(
      color: isActive ? surfaceHighlight : surfaceElevated,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isActive ? cardBorderHighlight : cardBorder,
        width: 1.0,
      ),
    );
  }

  static BoxDecoration glowCard({Color? glowColor, double radius = 18}) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: cardBorderHighlight,
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: CupertinoColors.white.withValues(alpha: 0.12),
          blurRadius: 22,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
