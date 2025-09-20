import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/environment_config.dart';
import '../models/models.dart';

/// Enhanced Steam API service with proper error handling and privacy
class SteamApiService {
  static final Dio _dio = Dio();
  static final Logger _logger = Logger();

  // Steam API endpoints
  static const String _steamApiBase = 'https://api.steampowered.com';
  static const String _steamStoreBase = 'https://store.steampowered.com/api';

  /// Fetch user's Steam profile (keeps Steam ID private)
  static Future<({bool success, SteamUserProfile? data, String? error})>
  fetchUserProfile({
    required String steamId,
    required String steamApiKey,
  }) async {
    try {
      _logger.i('Fetching Steam profile for user');
      _logger.d('Steam ID: $steamId');
      _logger.d('API Key: ${steamApiKey.substring(0, 8)}...');

      // Validate inputs
      if (!isValidSteamId(steamId)) {
        return (success: false, data: null, error: 'Invalid Steam ID format');
      }
      if (steamApiKey.isEmpty) {
        return (success: false, data: null, error: 'API key is empty');
      }

      final response = await _dio.get(
        '$_steamApiBase/ISteamUser/GetPlayerSummaries/v0002/',
        queryParameters: {'key': steamApiKey, 'steamids': steamId},
      );

      if (response.statusCode != 200) {
        return (
          success: false,
          data: null,
          error: 'Failed to fetch Steam profile',
        );
      }

      final data = response.data;
      _logger.d('Steam API response: $data');

      final players = data['response']['players'] as List<dynamic>? ?? [];

      if (players.isEmpty) {
        return (success: false, data: null, error: 'Steam profile not found');
      }

      final playerData = players.first as Map<String, dynamic>;
      _logger.d('Player data: $playerData');

      // Log each field individually to see types
      _logger.d('Field types:');
      playerData.forEach((key, value) {
        _logger.d('  $key: ${value.runtimeType} = $value');
      });

      // Validate required fields before creating profile
      if (playerData['steamid'] == null || playerData['personaname'] == null) {
        _logger.e(
          'Missing required fields: steamid=${playerData['steamid']}, personaname=${playerData['personaname']}',
        );
        return (
          success: false,
          data: null,
          error: 'Invalid Steam profile data - missing required fields',
        );
      }

      final profile = SteamUserProfile.fromJson(playerData);

      return (success: true, data: profile, error: null);
    } catch (e) {
      _logger.e('Error fetching Steam profile: $e');

      if (e is DioException) {
        switch (e.response?.statusCode) {
          case 403:
            return (
              success: false,
              data: null,
              error:
                  '403 Forbidden: Check your Steam API key and Steam ID. Make sure your API key is valid and the Steam ID is correct.',
            );
          case 401:
            return (
              success: false,
              data: null,
              error: '401 Unauthorized: Invalid Steam API key.',
            );
          case 400:
            return (
              success: false,
              data: null,
              error: '400 Bad Request: Invalid request parameters.',
            );
          default:
            return (
              success: false,
              data: null,
              error: 'HTTP ${e.response?.statusCode}: ${e.message}',
            );
        }
      }

      return (
        success: false,
        data: null,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Fetch user's owned games (filters for multiplayer)
  static Future<({bool success, List<SteamGame>? data, String? error})>
  fetchUserGames({required String steamId, required String steamApiKey}) async {
    try {
      _logger.i('Fetching Steam games for user');

      final response = await _dio.get(
        '$_steamApiBase/IPlayerService/GetOwnedGames/v0001/',
        queryParameters: {
          'key': steamApiKey,
          'steamid': steamId,
          'include_appinfo': true,
          'include_played_free_games': true,
        },
      );

      if (response.statusCode != 200) {
        return (
          success: false,
          data: null,
          error: 'Failed to fetch Steam games',
        );
      }

      final data = response.data;
      _logger.d('Steam games API response: $data');

      final games = data['response']['games'] as List<dynamic>? ?? [];
      _logger.d('Found ${games.length} games');

      // Log first game structure if available
      if (games.isNotEmpty) {
        final firstGame = games.first as Map<String, dynamic>;
        _logger.d('First game data: $firstGame');
        _logger.d('First game field types:');
        firstGame.forEach((key, value) {
          _logger.d('  $key: ${value.runtimeType} = $value');
        });
      }

      // Convert to SteamGame objects with null safety
      final steamGames = games
          .where(
            (game) => game is Map<String, dynamic> && game['appid'] != null,
          )
          .map((game) => SteamGame.fromJson(game as Map<String, dynamic>))
          .toList();

      // Filter for multiplayer games
      final multiplayerGames = steamGames
          .where((game) => game.isMultiplayer)
          .toList();

      _logger.i('Found ${multiplayerGames.length} multiplayer games');

      return (success: true, data: multiplayerGames, error: null);
    } catch (e) {
      _logger.e('Error fetching Steam games: $e');
      return (
        success: false,
        data: null,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Fetch detailed game information from Steam Store API
  static Future<({bool success, SteamGame? data, String? error})>
  fetchGameDetails(int appId) async {
    try {
      _logger.i('Fetching game details for app ID: $appId');

      final response = await _dio.get(
        '$_steamStoreBase/appdetails',
        queryParameters: {'appids': appId},
      );

      if (response.statusCode != 200) {
        return (
          success: false,
          data: null,
          error: 'Failed to fetch game details',
        );
      }

      final data = response.data;
      final gameData = data[appId.toString()]?['data'];

      if (gameData == null) {
        return (success: false, data: null, error: 'Game not found');
      }

      // Extract genres with null safety
      final genres = <String>[];
      if (gameData['genres'] is List) {
        for (final genre in gameData['genres'] as List) {
          if (genre is Map<String, dynamic> && genre['description'] is String) {
            genres.add(genre['description'] as String);
          }
        }
      }

      // Extract platforms
      final platforms = <String>[];
      if (gameData['platforms'] != null) {
        final platformData = gameData['platforms'] as Map<String, dynamic>;
        if (platformData['windows'] == true) platforms.add('Windows');
        if (platformData['mac'] == true) platforms.add('macOS');
        if (platformData['linux'] == true) platforms.add('Linux');
      }

      // Check if multiplayer
      final isMultiplayer = genres.any(
        (genre) => ['Multi-player', 'Co-op', 'Online PvP'].contains(genre),
      );

      final game = SteamGame(
        appId: appId,
        name: gameData['name'] ?? 'Unknown Game',
        description: gameData['short_description'],
        imageUrl: gameData['header_image'],
        headerImageUrl: gameData['header_image'],
        genres: genres,
        tags: _extractTags(gameData),
        isMultiplayer: isMultiplayer,
        platforms: platforms,
        releaseDate: gameData['release_date']?['date'] != null
            ? DateTime.tryParse(gameData['release_date']['date'])
            : null,
      );

      return (success: true, data: game, error: null);
    } catch (e) {
      _logger.e('Error fetching game details: $e');
      return (
        success: false,
        data: null,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Convert SteamGame to GameTinderGame for database storage
  static GameTinderGame steamGameToGameTinderGame(SteamGame steamGame) {
    return GameTinderGame(
      id: steamGame.appId.toString(),
      name: steamGame.name,
      description: steamGame.description ?? '',
      imageUrl: steamGame.imageUrl ?? '',
      genres: steamGame.genres,
      isMultiplayer: steamGame.isMultiplayer,
    );
  }

  /// Convert SteamUserProfile to GameTinderUser (privacy-focused)
  static GameTinderUser steamProfileToGameTinderUser({
    required SteamUserProfile profile,
    required List<SteamGame> games,
    required String internalUserId,
  }) {
    // Extract game IDs and playtimes
    final ownedGameIds = games.map((game) => game.appId.toString()).toList();
    final gamePlaytimes = Map<String, int>.fromEntries(
      games.map(
        (game) => MapEntry(game.appId.toString(), game.playtimeMinutes ?? 0),
      ),
    );

    return GameTinderUser(
      id: internalUserId, // Our internal ID, not Steam ID
      displayName: profile.displayName,
      avatarUrl: profile.avatarUrl ?? '',
      ownedGameIds: ownedGameIds,
      gamePlaytimes: gamePlaytimes,
      steamId: profile.steamId, // Private field, stays local
      steamApiKey: EnvironmentConfig.steamApiKey, // Private field, stays local
    );
  }

  /// Validate Steam ID format
  static bool isValidSteamId(String steamId) {
    // Steam IDs are 17-digit numbers
    final regex = RegExp(r'^\d{17}$');
    return regex.hasMatch(steamId);
  }

  /// Test Steam API key validity
  static Future<({bool success, String? error})> testApiKey({
    required String steamApiKey,
  }) async {
    try {
      _logger.i('Testing Steam API key validity');

      if (steamApiKey.isEmpty) {
        return (success: false, error: 'API key is empty');
      }

      // Use a known public Steam ID for testing
      const testSteamId = '76561197960435530'; // Gabe Newell's Steam ID

      final response = await _dio.get(
        '$_steamApiBase/ISteamUser/GetPlayerSummaries/v0002/',
        queryParameters: {'key': steamApiKey, 'steamids': testSteamId},
      );

      if (response.statusCode == 200) {
        return (success: true, error: null);
      } else {
        return (
          success: false,
          error: 'API key test failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is DioException) {
        switch (e.response?.statusCode) {
          case 403:
            return (success: false, error: '403 Forbidden: Invalid API key');
          case 401:
            return (success: false, error: '401 Unauthorized: Invalid API key');
          default:
            return (success: false, error: 'API key test failed: ${e.message}');
        }
      }
      return (success: false, error: 'API key test failed: ${e.toString()}');
    }
  }

  /// Extract Steam ID from Steam profile URL
  static String? extractSteamIdFromUrl(String profileUrl) {
    final regex = RegExp(r'steamcommunity\.com/(?:id|profiles)/([^/]+)');
    final match = regex.firstMatch(profileUrl);
    return match?.group(1);
  }

  /// Extract tags from game data with null safety
  static List<String> _extractTags(Map<String, dynamic> gameData) {
    final tags = <String>[];
    if (gameData['categories'] is List) {
      for (final cat in gameData['categories'] as List) {
        if (cat is Map<String, dynamic> && cat['description'] is String) {
          tags.add(cat['description'] as String);
        }
      }
    }
    return tags;
  }
}
