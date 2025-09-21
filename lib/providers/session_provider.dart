import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

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
  Timer? _refreshTimer;
  final Logger _logger = Logger();
  static const Duration _defaultSessionDuration = Duration(hours: 24);

  SessionNotifier() : super(const SessionState());

  /// Create a new session using Supabase
  Future<String?> createSession(
    String name,
    List<GameTinderUser> participants, {
    Duration? sessionDuration,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Generate unique session code
      final sessionCode = await _generateSessionCode();

      // Create session in Supabase
      final sessionResponse = await SupabaseService.from('sessions')
          .insert({
            'name': name,
            'host_user_id': participants.first.id,
            'session_code': sessionCode,
            'status': 'waiting',
          })
          .select()
          .single();

      // Add participants to the session
      for (final participant in participants) {
        await SupabaseService.from('session_participants').insert({
          'session_id': sessionResponse['id'],
          'user_id': participant.id,
        });
      }

      // Create local session object
      final session = GameTinderSession(
        sessionId: sessionResponse['id'],
        name: name,
        participants: participants,
        swipes: {},
        matches: [],
        createdAt: DateTime.parse(sessionResponse['created_at']),
        expiresAt: DateTime.now().add(
          sessionDuration ?? _defaultSessionDuration,
        ),
      );

      state = state.copyWith(currentSession: session, isLoading: false);

      // Set up real-time subscription for the new session
      setupRealtimeSubscription();

      return sessionCode; // Return the session code for sharing
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Join an existing session using Supabase
  Future<bool> joinSession(String sessionCode, GameTinderUser user) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Find session by code
      final sessionResponse = await SupabaseService.from('sessions')
          .select()
          .eq('session_code', sessionCode)
          .eq('status', 'waiting')
          .maybeSingle();

      if (sessionResponse == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Session not found or not available',
        );
        return false;
      }

      // Check if user is already in the session
      final existingParticipant =
          await SupabaseService.from('session_participants')
              .select()
              .eq('session_id', sessionResponse['id'])
              .eq('user_id', user.id)
              .maybeSingle();

      if (existingParticipant == null) {
        // Add user to session
        await SupabaseService.from(
          'session_participants',
        ).insert({'session_id': sessionResponse['id'], 'user_id': user.id});
      }

      // Get all participants
      final participantsResponse =
          await SupabaseService.from('session_participants')
              .select('''
            user_id,
            users!inner(id, display_name, avatar_url)
          ''')
              .eq('session_id', sessionResponse['id']);

      _logger.d('Join session - participants response: $participantsResponse');

      final participants = participantsResponse.map((p) {
        final userData = p['users'] as Map<String, dynamic>;
        final userId = userData['id'] ?? '';

        // Preserve Steam data for the current user
        if (userId == user.id) {
          return user; // Use the original user object with Steam data
        } else {
          return GameTinderUser(
            id: userId,
            displayName: userData['display_name'] ?? '',
            avatarUrl: userData['avatar_url'] ?? '',
            ownedGameIds: [], // Not stored in database
            gamePlaytimes: {}, // Not stored in database
          );
        }
      }).toList();

      _logger.i(
        'Join session - parsed participants: ${participants.map((p) => p.displayName).toList()}',
      );

      // Create session object
      final session = GameTinderSession(
        sessionId: sessionResponse['id'],
        name: sessionResponse['name'],
        participants: participants,
        swipes: {}, // TODO: Load existing swipes
        matches: [], // TODO: Load existing matches
        createdAt: DateTime.parse(sessionResponse['created_at']),
        expiresAt: DateTime.now().add(_defaultSessionDuration),
      );

      state = state.copyWith(
        currentSession: session,
        currentUser: user,
        isLoading: false,
      );

      // Set up real-time subscription for the joined session
      setupRealtimeSubscription();

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
      // Store swipe in Supabase
      await SupabaseService.from('swipes').upsert({
        'session_id': state.currentSession!.sessionId,
        'user_id': state.currentUser!.id,
        'game_id': gameId,
        'action': action,
      });

      // TODO: Check for matches and update local state
      // This would involve checking if all participants have swiped the same game

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Leave the current session
  void leaveSession() {
    _stopPeriodicRefresh();
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

  /// Refresh participants for the current session
  Future<void> refreshParticipants() async {
    if (state.currentSession == null) return;

    _logger.d(
      'Refreshing participants for session: ${state.currentSession!.sessionId}',
    );

    try {
      final participantsResponse =
          await SupabaseService.from('session_participants')
              .select('''
            user_id,
            users!inner(id, display_name, avatar_url)
          ''')
              .eq('session_id', state.currentSession!.sessionId);

      _logger.d('Participants response: $participantsResponse');

      final participants = participantsResponse.map<GameTinderUser>((p) {
        final userData = p['users'] as Map<String, dynamic>;
        final userId = userData['id'] ?? '';

        // Preserve Steam data for the current user if they're in the session
        final existingUser = state.currentSession?.participants
            .where((user) => user.id == userId)
            .firstOrNull;

        // If this is the current user and they have Steam data, preserve it
        if (existingUser?.steamId != null) {
          return existingUser!;
        } else {
          return GameTinderUser(
            id: userId,
            displayName: userData['display_name'] ?? '',
            avatarUrl: userData['avatar_url'] ?? '',
            ownedGameIds: [], // Not stored in database
            gamePlaytimes: {}, // Not stored in database
          );
        }
      }).toList();

      _logger.i(
        'Parsed participants: ${participants.map((p) => p.displayName).toList()}',
      );

      // Update the current session with new participants
      final updatedSession = state.currentSession!.copyWith(
        participants: participants,
      );

      state = state.copyWith(currentSession: updatedSession);
      _logger.i('Updated session with ${participants.length} participants');
    } catch (e) {
      _logger.e('Error refreshing participants: $e');
    }
  }

  /// Set up real-time subscription for session updates
  void setupRealtimeSubscription() {
    if (state.currentSession == null) return;

    _logger.d(
      'Setting up real-time subscription for session: ${state.currentSession!.sessionId}',
    );

    try {
      // Subscribe to session_participants table changes
      SupabaseService.subscribeToChannel('session_participants')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'session_id',
              value: state.currentSession!.sessionId,
            ),
            callback: (payload) {
              _logger.d('Real-time update received: $payload');
              // Refresh participants when changes occur
              refreshParticipants();
            },
          )
          .subscribe();
      _logger.i('Real-time subscription set up successfully');

      // Also start periodic refresh as backup
      _startPeriodicRefresh();
    } catch (e) {
      _logger.e('Error setting up real-time subscription: $e');
      // Fallback to periodic refresh only
      _startPeriodicRefresh();
    }
  }

  /// Start periodic refresh of participants
  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (state.currentSession != null) {
        _logger.d('Periodic refresh triggered');
        refreshParticipants();
      } else {
        timer.cancel();
      }
    });
    _logger.i('Started periodic refresh every 3 seconds');
  }

  /// Stop periodic refresh
  void _stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _logger.i('Stopped periodic refresh');
  }

  /// Generate a unique 8-character session code
  Future<String> _generateSessionCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    // Try up to 10 times to generate a unique code
    for (int attempt = 0; attempt < 10; attempt++) {
      final code = String.fromCharCodes(
        Iterable.generate(
          8,
          (_) => chars.codeUnitAt(random.nextInt(chars.length)),
        ),
      );

      // Check if code already exists in database
      try {
        final existingSession = await SupabaseService.from(
          'sessions',
        ).select('id').eq('session_code', code).maybeSingle();

        if (existingSession == null) {
          _logger.d('Generated unique session code: $code');
          return code;
        }

        _logger.w('Session code collision detected: $code, retrying...');
      } catch (e) {
        _logger.w(
          'Error checking session code uniqueness: $e, using generated code',
        );
        return code;
      }
    }

    // Fallback: use timestamp-based code if all attempts fail
    final fallbackCode = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(5);
    _logger.w('Using fallback session code: $fallbackCode');
    return fallbackCode;
  }
}

/// Provider for session management
final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((
  ref,
) {
  return SessionNotifier();
});
