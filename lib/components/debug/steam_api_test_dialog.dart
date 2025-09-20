import 'package:flutter/material.dart';
import '../../services/steam_api_service.dart';

/// Simple Steam API test dialog
class SteamApiTestDialog extends StatefulWidget {
  const SteamApiTestDialog({super.key});

  @override
  State<SteamApiTestDialog> createState() => _SteamApiTestDialogState();
}

class _SteamApiTestDialogState extends State<SteamApiTestDialog> {
  final _steamIdController = TextEditingController();
  final _apiKeyController = TextEditingController();
  String _result = 'Enter your Steam ID and API key to test';
  bool _isLoading = false;

  @override
  void dispose() {
    _steamIdController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Steam API Test',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _steamIdController,
              decoration: const InputDecoration(
                labelText: 'Steam ID (17 digits)',
                hintText: '76561198000000001',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'Steam API Key',
                hintText: 'Your Steam Web API key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testApi,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Test Steam API'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testApi() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing...\n';
    });

    try {
      final steamId = _steamIdController.text.trim();
      final apiKey = _apiKeyController.text.trim();

      if (steamId.isEmpty || apiKey.isEmpty) {
        setState(() {
          _result = 'Please enter both Steam ID and API key';
          _isLoading = false;
        });
        return;
      }

      _result += 'Steam ID: $steamId\n';
      _result += 'API Key: ${apiKey.substring(0, 8)}...\n\n';

      // Test validation
      final isValid = SteamApiService.isValidSteamId(steamId);
      _result +=
          'Steam ID validation: ${isValid ? "✅ Valid" : "❌ Invalid"}\n\n';

      if (!isValid) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Test API key first
      _result += 'Testing Steam API key...\n';
      final apiKeyTest = await SteamApiService.testApiKey(steamApiKey: apiKey);

      if (!apiKeyTest.success) {
        _result += '❌ API Key test failed: ${apiKeyTest.error}\n';
        _result += '\n💡 Troubleshooting:\n';
        _result +=
            '1. Check your Steam API key at: steamcommunity.com/dev/apikey\n';
        _result += '2. Make sure the key is active and not expired\n';
        _result += '3. Verify the key has the right permissions\n';
        setState(() {
          _isLoading = false;
        });
        return;
      }

      _result += '✅ API Key is valid!\n\n';

      // Test profile fetch
      _result += 'Fetching Steam profile...\n';
      final profileResult = await SteamApiService.fetchUserProfile(
        steamId: steamId,
        steamApiKey: apiKey,
      );

      if (profileResult.success && profileResult.data != null) {
        final profile = profileResult.data!;
        _result += '✅ Profile fetched successfully!\n';
        _result += 'Display Name: ${profile.displayName}\n';
        _result += 'Steam ID: ${profile.steamId}\n';
        _result += 'Avatar: ${profile.avatarUrl ?? "None"}\n\n';

        // Test games fetch
        _result += 'Fetching Steam games...\n';
        final gamesResult = await SteamApiService.fetchUserGames(
          steamId: steamId,
          steamApiKey: apiKey,
        );

        if (gamesResult.success && gamesResult.data != null) {
          final games = gamesResult.data!;
          _result += '✅ Games fetched successfully!\n';
          _result += 'Total multiplayer games: ${games.length}\n\n';

          if (games.isNotEmpty) {
            _result += 'Sample games:\n';
            for (int i = 0; i < 3 && i < games.length; i++) {
              final game = games[i];
              _result += '- ${game.name} (${game.appId})\n';
            }
          } else {
            _result += 'No multiplayer games found\n';
          }
        } else {
          _result += '❌ Failed to fetch games: ${gamesResult.error}\n';
        }
      } else {
        _result += '❌ Failed to fetch profile: ${profileResult.error}\n';
        _result += 'Check the console logs for detailed API response data\n';
      }
    } catch (e) {
      _result += '❌ Error: $e\n';
    }

    setState(() {
      _isLoading = false;
    });
  }
}
