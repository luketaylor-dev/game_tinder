import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Service class for Supabase operations
class SupabaseService {
  static SupabaseClient get _client {
    try {
      return SupabaseConfig.client;
    } catch (e) {
      throw StateError(
        'Supabase is not initialized. Please ensure the app has been properly started.',
      );
    }
  }

  /// Get the current authenticated user
  static User? get currentUser => _client.auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Sign in with Steam (placeholder for now)
  static Future<AuthResponse> signInWithSteam() async {
    // TODO: Implement Steam OAuth integration
    throw UnimplementedError('Steam OAuth not implemented yet');
  }

  /// Sign out the current user
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Subscribe to real-time changes
  static RealtimeChannel subscribeToChannel(String channel) {
    return _client.realtime.channel(channel);
  }

  /// Get a table reference
  static PostgrestQueryBuilder from(String table) {
    return _client.from(table);
  }

  /// Execute a function
  static PostgrestFilterBuilder rpc(String functionName) {
    return _client.rpc(functionName);
  }
}
