import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'config/supabase_config.dart';
import 'config/environment_config.dart';
import 'theme/game_tinder_theme.dart';
import 'screens/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await EnvironmentConfig.load();
    Logger().i('Environment variables loaded successfully');
  } catch (e) {
    Logger().e('Failed to load environment variables: $e');
  }

  // Initialize Supabase
  try {
    await SupabaseConfig.initialize();
    Logger().i('Supabase initialized successfully');
    Logger().i('Supabase URL: ${EnvironmentConfig.supabaseUrl}');
    Logger().i(
      'Supabase Key: ${EnvironmentConfig.supabaseAnonKey.substring(0, 20)}...',
    );
  } catch (e) {
    Logger().e('Failed to initialize Supabase: $e');
    Logger().e(
      'Please check your .env file and ensure Supabase credentials are correct',
    );
  }

  runApp(const ProviderScope(child: GameTinderApp()));
}

class GameTinderApp extends StatelessWidget {
  const GameTinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Tinder',
      theme: GameTinderTheme.lightTheme,
      darkTheme: GameTinderTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
