import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Landing page form state
class LandingPageFormState {
  final String displayName;
  final String steamId;
  final String steamApiKey;
  final bool useSteamIntegration;
  final bool isLoading;
  final String? errorMessage;

  const LandingPageFormState({
    this.displayName = '',
    this.steamId = '',
    this.steamApiKey = '',
    this.useSteamIntegration = true,
    this.isLoading = false,
    this.errorMessage,
  });

  LandingPageFormState copyWith({
    String? displayName,
    String? steamId,
    String? steamApiKey,
    bool? useSteamIntegration,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LandingPageFormState(
      displayName: displayName ?? this.displayName,
      steamId: steamId ?? this.steamId,
      steamApiKey: steamApiKey ?? this.steamApiKey,
      useSteamIntegration: useSteamIntegration ?? this.useSteamIntegration,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Landing page form notifier
class LandingPageFormNotifier extends StateNotifier<LandingPageFormState> {
  LandingPageFormNotifier() : super(const LandingPageFormState());

  void updateDisplayName(String value) {
    state = state.copyWith(displayName: value);
  }

  void updateSteamId(String value) {
    state = state.copyWith(steamId: value);
  }

  void updateSteamApiKey(String value) {
    state = state.copyWith(steamApiKey: value);
  }

  void toggleSteamIntegration(bool value) {
    state = state.copyWith(useSteamIntegration: value);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void setDemoMode() {
    state = state.copyWith(
      displayName: 'Demo User',
      useSteamIntegration: false,
      steamId: '',
      steamApiKey: '',
    );
  }
}

/// Provider for landing page form state
final landingPageFormProvider =
    StateNotifierProvider<LandingPageFormNotifier, LandingPageFormState>((ref) {
      return LandingPageFormNotifier();
    });
