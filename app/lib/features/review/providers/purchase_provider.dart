import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Purchase state
class PurchaseState {
  final bool isUnlocked;
  final bool isLoading;
  final String? error;

  const PurchaseState({
    this.isUnlocked = false,
    this.isLoading = false,
    this.error,
  });

  PurchaseState copyWith({
    bool? isUnlocked,
    bool? isLoading,
    String? error,
  }) {
    return PurchaseState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Purchase provider
final purchaseProvider =
    StateNotifierProvider<PurchaseNotifier, PurchaseState>((ref) {
  return PurchaseNotifier();
});

/// Purchase state notifier
class PurchaseNotifier extends StateNotifier<PurchaseState> {
  static const _purchaseKey = 'swipeclear_unlocked';

  PurchaseNotifier() : super(const PurchaseState()) {
    _loadPurchaseState();
  }

  Future<void> _loadPurchaseState() async {
    final prefs = await SharedPreferences.getInstance();
    final isUnlocked = prefs.getBool(_purchaseKey) ?? false;
    state = state.copyWith(isUnlocked: isUnlocked);
  }

  /// Initiate purchase
  /// TODO: Replace with actual IAP implementation
  Future<void> purchase() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate purchase delay
      await Future.delayed(const Duration(seconds: 2));

      // For development: auto-unlock
      // In production, this would use in_app_purchase package
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_purchaseKey, true);

      state = state.copyWith(isUnlocked: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Purchase failed. Please try again.',
      );
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate restore delay
      await Future.delayed(const Duration(seconds: 1));

      // Check stored purchase state
      final prefs = await SharedPreferences.getInstance();
      final isUnlocked = prefs.getBool(_purchaseKey) ?? false;

      state = state.copyWith(isUnlocked: isUnlocked, isLoading: false);

      if (!isUnlocked) {
        state = state.copyWith(error: 'No previous purchase found.');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Restore failed. Please try again.',
      );
    }
  }

  /// For testing: unlock directly
  Future<void> unlockForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_purchaseKey, true);
    state = state.copyWith(isUnlocked: true);
  }

  /// For testing: reset purchase
  Future<void> resetPurchase() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_purchaseKey);
    state = state.copyWith(isUnlocked: false);
  }
}
