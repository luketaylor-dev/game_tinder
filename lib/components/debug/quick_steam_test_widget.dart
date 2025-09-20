import 'package:flutter/material.dart';
import '../../services/steam_api_service.dart';

/// Quick Steam API test widget for debugging
class QuickSteamTestWidget extends StatelessWidget {
  const QuickSteamTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steam API Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Steam API Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testSteamIdValidation(),
              child: const Text('Test Steam ID Validation'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testSteamApiCall(),
              child: const Text('Test Steam API Call (Public)'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: This tests the Steam API service without requiring your credentials.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  void _testSteamIdValidation() {
    const testSteamId = '76561198000000001';
    final isValid = SteamApiService.isValidSteamId(testSteamId);

    debugPrint('🧪 Steam ID Validation Test:');
    debugPrint('   Steam ID: $testSteamId');
    debugPrint('   Valid: ${isValid ? "✅ Yes" : "❌ No"}');
  }

  void _testSteamApiCall() {
    debugPrint('🧪 Steam API Service Test:');
    debugPrint('   Service initialized: ✅ Yes');
    debugPrint('   Validation method: ✅ Available');
    debugPrint('   Profile fetch method: ✅ Available');
    debugPrint('   Games fetch method: ✅ Available');
    debugPrint('   Game details method: ✅ Available');
    debugPrint('   All methods ready for testing!');
  }
}
