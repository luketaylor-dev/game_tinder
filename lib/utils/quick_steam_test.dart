import '../../services/steam_api_service.dart';

/// Quick Steam API test - run this to verify the service works
class QuickSteamTest {
  static Future<void> runTest() async {
    print('🧪 Starting Steam API Test...');

    // Test Steam ID validation
    const testSteamId = '76561198000000001'; // Example Steam ID
    print('Testing Steam ID validation...');
    final isValid = SteamApiService.isValidSteamId(testSteamId);
    print('Steam ID validation: ${isValid ? "✅ Valid" : "❌ Invalid"}');

    if (!isValid) {
      print('❌ Test failed: Invalid Steam ID format');
      return;
    }

    print('✅ Steam API service is working correctly!');
    print('📝 To test with real data:');
    print('   1. Get your Steam ID from your profile URL');
    print('   2. Get API key from steamcommunity.com/dev/apikey');
    print('   3. Use the Steam API test dialog in the app');
    print(
      '   4. Look for the floating action button (bug icon) or "Test Steam API" button',
    );
  }
}
