import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradient definitions for visual polish
class AppGradients {
  AppGradients._();

  // Primary accent gradients (indigo → violet)
  static const LinearGradient accentLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo 500
      Color(0xFF8B5CF6), // Violet 500
    ],
  );

  static const LinearGradient accentDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF818CF8), // Indigo 400
      Color(0xFFA78BFA), // Violet 400
    ],
  );

  // Subtle background gradients
  static const LinearGradient backgroundLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFF5F3FF), // Very subtle violet tint
    ],
  );

  static const LinearGradient backgroundDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A0A0A),
      Color(0xFF0F0A1A), // Very subtle violet tint
    ],
  );

  // Card surface gradients (subtle shimmer effect)
  static const LinearGradient cardLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFBFAFF), // Hint of violet
    ],
  );

  static const LinearGradient cardDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A1F),
      Color(0xFF171720), // Hint of violet
    ],
  );

  // Keep/Delete action gradients
  static const LinearGradient keepGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981), // Emerald 500
      Color(0xFF059669), // Emerald 600
    ],
  );

  static const LinearGradient deleteGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEF4444), // Red 500
      Color(0xFFDC2626), // Red 600
    ],
  );

  // Semantic gradient getters
  static LinearGradient accent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? accentLight
          : accentDark;

  static LinearGradient background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? backgroundLight
          : backgroundDark;

  static LinearGradient card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? cardLight
          : cardDark;
}

/// Polished shadow definitions
class AppShadows {
  AppShadows._();

  // Soft elevation shadows for light mode
  static List<BoxShadow> cardLight = [
    BoxShadow(
      color: const Color(0xFF6366F1).withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  // Subtle glow for dark mode
  static List<BoxShadow> cardDark = [
    BoxShadow(
      color: const Color(0xFF818CF8).withOpacity(0.1),
      blurRadius: 32,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  // Elevated shadows (buttons, FABs)
  static List<BoxShadow> elevatedLight = [
    BoxShadow(
      color: const Color(0xFF6366F1).withOpacity(0.25),
      blurRadius: 16,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF6366F1).withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> elevatedDark = [
    BoxShadow(
      color: const Color(0xFF818CF8).withOpacity(0.2),
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  // Semantic shadow getters
  static List<BoxShadow> card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? cardLight
          : cardDark;

  static List<BoxShadow> elevated(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? elevatedLight
          : elevatedDark;
}
