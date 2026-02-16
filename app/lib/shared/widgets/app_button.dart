import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// App button variants
enum AppButtonVariant {
  /// Filled button with accent color
  primary,

  /// Outlined button with border
  secondary,

  /// Text-only button
  text,
}

/// Reusable button component with consistent styling
class AppButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Button variant (primary, secondary, text)
  final AppButtonVariant variant;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Optional icon to display before text
  final IconData? icon;

  /// Whether to expand button to full width
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.variant = AppButtonVariant.primary,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  /// Primary button factory
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = true,
  }) =>
      AppButton(
        text: text,
        variant: AppButtonVariant.primary,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        fullWidth: fullWidth,
      );

  /// Secondary button factory
  factory AppButton.secondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = true,
  }) =>
      AppButton(
        text: text,
        variant: AppButtonVariant.secondary,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        fullWidth: fullWidth,
      );

  /// Text button factory
  factory AppButton.text({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) =>
      AppButton(
        text: text,
        variant: AppButtonVariant.text,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        fullWidth: false,
      );

  @override
  Widget build(BuildContext context) {
    final child = _buildButtonContent(context);

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AppButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
    }

    if (fullWidth) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          minHeight: AppConstants.minTouchTarget,
        ),
        child: button,
      );
    }

    return button;
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary
                ? Colors.white
                : AppColors.accent(context),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppConstants.spacingXs),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }

    return Text(text);
  }
}
