import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Steam API Configuration
  static String get steamApiKey => dotenv.env['STEAM_API_KEY'] ?? '';

  // App Configuration
  static bool get isDebug => dotenv.env['DEBUG']?.toLowerCase() == 'true';

  /// Initialize environment variables from .env file
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
