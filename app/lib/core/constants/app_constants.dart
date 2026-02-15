/// App-wide constants for spacing, sizing, and animation durations
class AppConstants {
  AppConstants._();

  // ============== SPACING ==============
  /// 4dp - Smallest spacing
  static const double spacingXxs = 4;

  /// 8dp - Extra small spacing
  static const double spacingXs = 8;

  /// 12dp - Small spacing
  static const double spacingSm = 12;

  /// 16dp - Medium spacing (default)
  static const double spacingMd = 16;

  /// 24dp - Large spacing
  static const double spacingLg = 24;

  /// 32dp - Extra large spacing
  static const double spacingXl = 32;

  /// 48dp - 2x large spacing
  static const double spacing2xl = 48;

  /// 64dp - 3x large spacing
  static const double spacing3xl = 64;

  // ============== BORDER RADIUS ==============
  /// 6dp - Badge radius
  static const double radiusBadge = 6;

  /// 8dp - Small radius
  static const double radiusSm = 8;

  /// 12dp - Button radius
  static const double radiusButton = 12;

  /// 16dp - Card radius
  static const double radiusCard = 16;

  /// 999dp - Pill/full round radius
  static const double radiusFull = 999;

  // ============== SWIPE BEHAVIOR ==============
  /// Position threshold to trigger swipe (dp)
  static const double swipeThreshold = 100.0;

  /// Velocity threshold to trigger swipe (pixels/second)
  static const double swipeVelocityThreshold = 1000.0;

  /// Maximum rotation angle during swipe (degrees)
  static const double swipeMaxRotation = 15.0;

  /// Background card scale factor
  static const double cardScaleStep = 0.05;

  /// Background card offset step (dp)
  static const double cardOffsetStep = 8.0;

  // ============== ANIMATION DURATIONS ==============
  /// Quick animations (micro-interactions)
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Standard animations
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Normal/standard animation (alias for durationMedium)
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// Slow animations (emphasis)
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// Card stack animation
  static const Duration durationCardStack = Duration(milliseconds: 200);

  // Vortex animation phases
  static const Duration durationVortexGather = Duration(milliseconds: 400);
  static const Duration durationVortexSpiral = Duration(milliseconds: 800);
  static const Duration durationVortexImplosion = Duration(milliseconds: 200);
  static const Duration durationVortexExpansion = Duration(milliseconds: 400);
  static const Duration durationVortexCelebration = Duration(milliseconds: 600);

  /// Stagger delay between file animations (ms)
  static const int vortexStaggerMs = 30;

  // ============== SIZING ==============
  /// Minimum touch target size (accessibility)
  static const double minTouchTarget = 48.0;

  /// App icon size on onboarding
  static const double onboardingIconSize = 96.0;

  /// Number of visible cards in stack
  static const int visibleCards = 3;

  /// Review grid columns
  static const int reviewGridColumns = 5;

  // ============== SHADOWS (Light mode) ==============
  /// Card shadow
  static const List<double> cardShadow = [0, 2, 8, 0.08]; // [x, y, blur, opacity]

  /// Elevated shadow
  static const List<double> elevatedShadow = [0, 4, 16, 0.12];

  // ============== SPRING PHYSICS ==============
  /// Spring mass for swipe animations
  static const double springMass = 1;

  /// Spring stiffness for swipe animations
  static const double springStiffness = 500;

  /// Spring damping for swipe animations
  static const double springDamping = 25;
}
