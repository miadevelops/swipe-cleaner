import 'package:flutter/services.dart';

/// Haptic feedback helper functions using Flutter's built-in HapticFeedback
class Haptics {
  Haptics._();

  /// Initialize haptics - no-op for built-in haptics
  static Future<void> init() async {
    // Built-in HapticFeedback doesn't need initialization
  }

  /// Light impact - for subtle feedback (threshold cross)
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact - for confirmations (swipe release)
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact - for strong feedback (implosion)
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click - for selection changes
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Success pattern - for completion celebrations
  static Future<void> success() async {
    // Pattern: heavy -> delay -> medium -> delay -> light
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  /// Tiny pulse - for vortex per-file feedback
  static Future<void> tinyPulse() async {
    await HapticFeedback.lightImpact();
  }
}
