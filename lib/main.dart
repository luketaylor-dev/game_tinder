import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/game_tinder_theme.dart';
import 'screens/landing_page.dart';

void main() {
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
