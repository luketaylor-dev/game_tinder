import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';
import '../services/steam_api_service.dart';

part 'steam_provider.freezed.dart';

/// Provider for Steam API service
final steamApiServiceProvider = Provider<SteamApiService>((ref) {
  return SteamApiService();
});

/// Provider for Steam user profile state
final steamProfileProvider =
    StateNotifierProvider<SteamProfileNotifier, AsyncValue<SteamUserProfile?>>((
      ref,
    ) {
      return SteamProfileNotifier();
    });

/// Provider for Steam games state
final steamGamesProvider =
    StateNotifierProvider<SteamGamesNotifier, AsyncValue<List<SteamGame>>>((
      ref,
    ) {
      return SteamGamesNotifier();
    });

/// Provider for Steam authentication state
final steamAuthProvider =
    StateNotifierProvider<SteamAuthNotifier, SteamAuthState>((ref) {
      return SteamAuthNotifier();
    });

/// Steam profile notifier
class SteamProfileNotifier
    extends StateNotifier<AsyncValue<SteamUserProfile?>> {
  SteamProfileNotifier() : super(const AsyncValue.data(null));

  Future<void> fetchProfile({
    required String steamId,
    required String steamApiKey,
  }) async {
    state = const AsyncValue.loading();

    final response = await SteamApiService.fetchUserProfile(
      steamId: steamId,
      steamApiKey: steamApiKey,
    );

    if (response.success && response.data != null) {
      state = AsyncValue.data(response.data);
    } else {
      state = AsyncValue.error(
        response.error ?? 'Failed to fetch Steam profile',
        StackTrace.current,
      );
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

/// Steam games notifier
class SteamGamesNotifier extends StateNotifier<AsyncValue<List<SteamGame>>> {
  SteamGamesNotifier() : super(const AsyncValue.data([]));

  Future<void> fetchGames({
    required String steamId,
    required String steamApiKey,
  }) async {
    state = const AsyncValue.loading();

    final response = await SteamApiService.fetchUserGames(
      steamId: steamId,
      steamApiKey: steamApiKey,
    );

    if (response.success && response.data != null) {
      state = AsyncValue.data(response.data!);
    } else {
      state = AsyncValue.error(
        response.error ?? 'Failed to fetch Steam games',
        StackTrace.current,
      );
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// Steam authentication state
@freezed
class SteamAuthState with _$SteamAuthState {
  const factory SteamAuthState({
    @Default(false) bool isAuthenticated,
    String? steamId,
    String? steamApiKey,
    String? displayName,
    @Default(false) bool isLoading,
    String? error,
  }) = _SteamAuthState;
}

/// Steam authentication notifier
class SteamAuthNotifier extends StateNotifier<SteamAuthState> {
  SteamAuthNotifier() : super(const SteamAuthState());

  Future<void> authenticate({
    required String steamId,
    required String steamApiKey,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Validate Steam ID format
      if (!SteamApiService.isValidSteamId(steamId)) {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid Steam ID format',
        );
        return;
      }

      // Test API key by fetching profile
      final profileResponse = await SteamApiService.fetchUserProfile(
        steamId: steamId,
        steamApiKey: steamApiKey,
      );

      if (profileResponse.success && profileResponse.data != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          steamId: steamId,
          steamApiKey: steamApiKey,
          displayName: profileResponse.data!.displayName,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: profileResponse.error ?? 'Authentication failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  void signOut() {
    state = const SteamAuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for creating GameTinderUser from Steam data
final gameTinderUserFromSteamProvider = Provider<GameTinderUser?>((ref) {
  final steamProfile = ref.watch(steamProfileProvider);
  final steamGames = ref.watch(steamGamesProvider);
  final steamAuth = ref.watch(steamAuthProvider);

  if (steamProfile.hasValue &&
      steamGames.hasValue &&
      steamAuth.isAuthenticated &&
      steamAuth.steamId != null) {
    return SteamApiService.steamProfileToGameTinderUser(
      profile: steamProfile.value!,
      games: steamGames.value!,
      internalUserId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  return null;
});
