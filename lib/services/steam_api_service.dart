import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Steam API service for fetching user game data
/// Keeps Steam IDs and API keys private (local only)
class SteamApiService {
  static const String _baseUrl = 'https://api.steampowered.com';

  /// Fetch user's Steam profile and games (keeps Steam ID private)
  static Future<GameTinderUser?> fetchUserProfile({
    required String steamId,
    required String steamApiKey,
    required String displayName,
  }) async {
    try {
      // Generate our internal user ID (not Steam ID)
      final internalUserId = DateTime.now().millisecondsSinceEpoch.toString();

      // Fetch Steam profile
      final profileResponse = await http.get(
        Uri.parse(
          '$_baseUrl/ISteamUser/GetPlayerSummaries/v0002/?key=$steamApiKey&steamids=$steamId',
        ),
      );

      if (profileResponse.statusCode != 200) {
        throw Exception('Failed to fetch Steam profile');
      }

      final profileData = jsonDecode(profileResponse.body);
      final playerData = profileData['response']['players'][0];

      // Fetch owned games
      final gamesResponse = await http.get(
        Uri.parse(
          '$_baseUrl/IPlayerService/GetOwnedGames/v0001/?key=$steamApiKey&steamid=$steamId&include_appinfo=true&include_played_free_games=true',
        ),
      );

      if (gamesResponse.statusCode != 200) {
        throw Exception('Failed to fetch Steam games');
      }

      final gamesData = jsonDecode(gamesResponse.body);
      final games = gamesData['response']['games'] as List<dynamic>;

      // Filter to multiplayer games only
      final multiplayerGames = games.where((game) {
        final categories = game['categories'] as List<dynamic>? ?? [];
        return categories.any((cat) => cat['description'] == 'Multi-player');
      }).toList();

      // Extract game data
      final ownedGameIds = multiplayerGames
          .map((game) => game['appid'].toString())
          .toList();
      final gamePlaytimes = Map<String, int>.fromEntries(
        multiplayerGames.map(
          (game) =>
              MapEntry(game['appid'].toString(), game['playtime_forever'] ?? 0),
        ),
      );

      // Create user with our internal ID (Steam ID stays private)
      return GameTinderUser(
        id: internalUserId, // Our ID, not Steam ID
        displayName: displayName.isNotEmpty
            ? displayName
            : playerData['personaname'] ?? 'Steam User',
        avatarUrl: playerData['avatar'] ?? 'https://via.placeholder.com/64',
        ownedGameIds: ownedGameIds,
        gamePlaytimes: gamePlaytimes,
        steamId: steamId, // Private field, not sent to server
        steamApiKey: steamApiKey, // Private field, not sent to server
      );
    } catch (e) {
      print('Steam API error: $e');
      return null;
    }
  }

  /// Fetch detailed game information
  static Future<GameTinderGame?> fetchGameDetails(String gameId) async {
    try {
      // Use Steam Store API (no API key needed for basic info)
      final response = await http.get(
        Uri.parse(
          'https://store.steampowered.com/api/appdetails?appids=$gameId',
        ),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);
      final gameData = data[gameId]['data'];

      if (gameData == null) return null;

      // Extract genres
      final genres =
          (gameData['genres'] as List<dynamic>?)
              ?.map((genre) => genre['description'] as String)
              .toList() ??
          [];

      return GameTinderGame(
        id: gameId,
        name: gameData['name'] ?? 'Unknown Game',
        description: gameData['short_description'] ?? '',
        imageUrl:
            gameData['header_image'] ?? 'https://via.placeholder.com/300x200',
        genres: genres,
        isMultiplayer: genres.any(
          (genre) => ['Multi-player', 'Co-op', 'Online PvP'].contains(genre),
        ),
      );
    } catch (e) {
      print('Game details error: $e');
      return null;
    }
  }

  /// Refresh user's game library (updates games but keeps Steam ID private)
  static Future<GameTinderUser?> refreshUserGames(GameTinderUser user) async {
    if (user.steamId == null || user.steamApiKey == null) {
      throw Exception('Steam credentials not available');
    }

    final updatedUser = await fetchUserProfile(
      steamId: user.steamId!,
      steamApiKey: user.steamApiKey!,
      displayName: user.displayName,
    );

    if (updatedUser != null) {
      // Keep the same internal user ID
      return GameTinderUser(
        id: user.id, // Keep our internal ID
        displayName: updatedUser.displayName,
        avatarUrl: updatedUser.avatarUrl,
        ownedGameIds: updatedUser.ownedGameIds,
        gamePlaytimes: updatedUser.gamePlaytimes,
        steamId: user.steamId, // Keep private Steam data
        steamApiKey: user.steamApiKey,
      );
    }

    return null;
  }
}
