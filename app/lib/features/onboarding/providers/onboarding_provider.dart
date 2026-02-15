import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingSeenKey = 'onboarding_seen';

/// Provider for onboarding state
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

/// State for onboarding
class OnboardingState {
  final bool isLoading;
  final bool hasSeenOnboarding;

  const OnboardingState({
    this.isLoading = true,
    this.hasSeenOnboarding = false,
  });

  OnboardingState copyWith({
    bool? isLoading,
    bool? hasSeenOnboarding,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}

/// Notifier for onboarding state
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState()) {
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(_kOnboardingSeenKey) ?? false;
    state = state.copyWith(
      isLoading: false,
      hasSeenOnboarding: seen,
    );
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingSeenKey, true);
    state = state.copyWith(hasSeenOnboarding: true);
  }

  /// For testing: reset onboarding state
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kOnboardingSeenKey);
    state = state.copyWith(hasSeenOnboarding: false);
  }
}
