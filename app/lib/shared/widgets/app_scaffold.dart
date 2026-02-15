import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Consistent scaffold wrapper for all screens
class AppScaffold extends StatelessWidget {
  /// Screen title (optional)
  final String? title;

  /// Screen body content
  final Widget body;

  /// Whether to show back button
  final bool showBackButton;

  /// Custom back button action
  final VoidCallback? onBack;

  /// Optional trailing widget in app bar
  final Widget? trailing;

  /// Optional bottom widget (persistent footer)
  final Widget? bottomWidget;

  /// Padding for the body content
  final EdgeInsets? padding;

  /// Whether to use safe area
  final bool useSafeArea;

  /// Background color override
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.showBackButton = false,
    this.onBack,
    this.trailing,
    this.bottomWidget,
    this.padding,
    this.useSafeArea = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    // Apply padding if specified
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Apply safe area if enabled
    if (useSafeArea) {
      content = SafeArea(
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background(context),
      appBar: _buildAppBar(context),
      body: content,
      bottomNavigationBar: bottomWidget != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: bottomWidget,
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    // Don't show app bar if no title and no back button
    if (title == null && !showBackButton && trailing == null) {
      return null;
    }

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge,
            )
          : null,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      automaticallyImplyLeading: showBackButton,
      actions: trailing != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: AppConstants.spacingXs),
                child: trailing,
              ),
            ]
          : null,
    );
  }
}

/// Extension to easily wrap content with standard screen padding
extension AppScaffoldPadding on Widget {
  /// Wrap with standard horizontal padding
  Widget withScreenPadding() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
      ),
      child: this,
    );
  }

  /// Wrap with full screen padding (horizontal + vertical)
  Widget withFullPadding() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: this,
    );
  }
}
