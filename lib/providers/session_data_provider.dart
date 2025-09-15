import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tinder/providers/session_provider.dart';
import '../models/models.dart';

/// Provider for current session
final currentSessionProvider = Provider<GameTinderSession?>((ref) {
  return ref.watch(sessionProvider).currentSession;
});

/// Provider for current user
final currentUserProvider = Provider<GameTinderUser?>((ref) {
  return ref.watch(sessionProvider).currentUser;
});

/// Provider for swipeable games
final swipeableGamesProvider = Provider<List<String>>((ref) {
  final session = ref.watch(currentSessionProvider);
  final user = ref.watch(currentUserProvider);

  if (session == null || user == null) return [];

  return session.getSwipeableGames(user.id);
});

/// Provider for matches
final matchesProvider = Provider<List<String>>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.matches ?? [];
});

/// Provider for mutual games
final mutualGamesProvider = Provider<List<String>>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.mutualGames ?? [];
});
