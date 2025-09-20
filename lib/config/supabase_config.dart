import 'package:supabase_flutter/supabase_flutter.dart';
import 'environment_config.dart';

class SupabaseConfig {
  static String get supabaseUrl => EnvironmentConfig.supabaseUrl;
  static String get supabaseAnonKey => EnvironmentConfig.supabaseAnonKey;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // Set to false in production
    );
  }

  static SupabaseClient get client {
    if (!Supabase.instance.isInitialized) {
      throw StateError(
        'Supabase is not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return Supabase.instance.client;
  }
}
