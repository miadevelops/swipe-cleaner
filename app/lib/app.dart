import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/folder_picker/screens/folder_picker_screen.dart';
import 'features/swipe/screens/swipe_screen.dart';
import 'features/review/screens/review_screen.dart';
import 'features/delete/screens/delete_animation_screen.dart';

/// Main app widget with theme and routing configuration
class SwipeClearApp extends StatelessWidget {
  const SwipeClearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final onboardingState = ref.watch(onboardingProvider);

          return MaterialApp.router(
            title: 'SwipeClear',
            debugShowCheckedModeBanner: false,

            // Theme configuration - follows system
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,

            // Router configuration
            routerConfig: _createRouter(onboardingState),
          );
        },
      ),
    );
  }

  static GoRouter _createRouter(OnboardingState onboardingState) {
    return GoRouter(
      initialLocation: '/onboarding',
      redirect: (context, state) {
        // Still loading onboarding state
        if (onboardingState.isLoading) {
          return null;
        }

        // If onboarding is seen and we're on the onboarding screen, redirect
        if (onboardingState.hasSeenOnboarding &&
            state.matchedLocation == '/onboarding') {
          return '/folder-picker';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/folder-picker',
          builder: (context, state) => const FolderPickerScreen(),
        ),
        GoRoute(
          path: '/swipe',
          builder: (context, state) => const SwipeScreen(),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => const ReviewScreen(),
        ),
        GoRoute(
          path: '/delete',
          builder: (context, state) => const DeleteAnimationScreen(),
        ),
      ],
    );
  }
}
