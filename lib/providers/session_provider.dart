import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Session state management
class SessionState {
  final GameTinderSession? currentSession;
  final GameTinderUser? currentUser;
  final bool isLoading;
  final String? error;

  const SessionState({
    this.currentSession,
    this.currentUser,
    this.isLoading = false,
    this.error,
  });

  SessionState copyWith({
    GameTinderSession? currentSession,
    GameTinderUser? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return SessionState(
      currentSession: currentSession ?? this.currentSession,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Session manager notifier
class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  // Mock server URL (in production, this would be your temporary session server)
  static const String _baseUrl =
      'http://localhost:3000'; // Or use a free service like Railway/Render

  /// Create a new session
  Future<String?> createSession(
    String name,
    List<GameTinderUser> participants,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      final session = GameTinderSession(
        sessionId: sessionId,
        name: name,
        participants: participants,
        swipes: {},
        matches: [],
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      // In a real app, you'd POST to your session server
      // For now, we'll simulate it
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(currentSession: session, isLoading: false);

      return sessionId;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Join an existing session
  Future<bool> joinSession(String sessionId, GameTinderUser user) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // In a real app, you'd GET the session from your server
      // For now, we'll simulate it
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock session data
      final session = GameTinderSession(
        sessionId: sessionId,
        name: 'Gaming Session',
        participants: [user], // In real app, this would come from server
        swipes: {},
        matches: [],
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      state = state.copyWith(
        currentSession: session,
        currentUser: user,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Perform a swipe action
  Future<void> swipe(String gameId, String action) async {
    if (state.currentSession == null || state.currentUser == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final swipeKey = '${gameId}_${state.currentUser!.id}';
      final swipe = SwipeAction(
        gameId: gameId,
        userId: state.currentUser!.id,
        action: action,
        timestamp: DateTime.now(),
      );

      // Update local session
      final updatedSwipes = Map<String, SwipeAction>.from(
        state.currentSession!.swipes,
      );
      updatedSwipes[swipeKey] = swipe;

      final updatedSession = GameTinderSession(
        sessionId: state.currentSession!.sessionId,
        name: state.currentSession!.name,
        participants: state.currentSession!.participants,
        swipes: updatedSwipes,
        matches: state.currentSession!.matches,
        createdAt: state.currentSession!.createdAt,
        expiresAt: state.currentSession!.expiresAt,
      );

      // Check for matches
      final updatedMatches = List<String>.from(updatedSession.matches);
      if (action == 'like' && updatedSession.isGameMatched(gameId)) {
        if (!updatedMatches.contains(gameId)) {
          updatedMatches.add(gameId);
        }
      }

      final finalSession = GameTinderSession(
        sessionId: updatedSession.sessionId,
        name: updatedSession.name,
        participants: updatedSession.participants,
        swipes: updatedSwipes,
        matches: updatedMatches,
        createdAt: updatedSession.createdAt,
        expiresAt: updatedSession.expiresAt,
      );

      state = state.copyWith(currentSession: finalSession, isLoading: false);

      // In a real app, you'd POST the swipe to your server
      // await http.post(
      //   Uri.parse('$_baseUrl/sessions/${state.currentSession!.sessionId}/swipes'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(swipe.toMap()),
      // );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Leave the current session
  void leaveSession() {
    state = const SessionState();
  }

  /// Set current user
  void setCurrentUser(GameTinderUser user) {
    state = state.copyWith(currentUser: user);
  }

  /// Clear current user (for navigation back to setup)
  void clearCurrentUser() {
    state = state.copyWith(currentUser: null);
  }
}

/// Provider for session management
final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((
  ref,
) {
  return SessionNotifier();
});
