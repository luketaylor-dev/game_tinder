import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Mock Steam API service for development
class MockSteamService {
  /// Generate mock games for testing
  static List<GameTinderGame> getMockGames() {
    return [
      const GameTinderGame(
        id: '730',
        name: 'Counter-Strike 2',
        description: 'Tactical FPS game',
        imageUrl: 'https://via.placeholder.com/300x200',
        genres: ['FPS', 'Multiplayer'],
        isMultiplayer: true,
      ),
      const GameTinderGame(
        id: '570',
        name: 'Dota 2',
        description: 'MOBA game',
        imageUrl: 'https://via.placeholder.com/300x200',
        genres: ['MOBA', 'Multiplayer'],
        isMultiplayer: true,
      ),
      const GameTinderGame(
        id: '1172470',
        name: 'Apex Legends',
        description: 'Battle Royale FPS',
        imageUrl: 'https://via.placeholder.com/300x200',
        genres: ['FPS', 'Battle Royale'],
        isMultiplayer: true,
      ),
      const GameTinderGame(
        id: '271590',
        name: 'Grand Theft Auto V',
        description: 'Open world action game',
        imageUrl: 'https://via.placeholder.com/300x200',
        genres: ['Action', 'Open World'],
        isMultiplayer: true,
      ),
      const GameTinderGame(
        id: '1091500',
        name: 'Cyberpunk 2077',
        description: 'Futuristic RPG',
        imageUrl: 'https://via.placeholder.com/300x200',
        genres: ['RPG', 'Action'],
        isMultiplayer: false,
      ),
    ];
  }

  /// Generate mock user with games (privacy-focused)
  static GameTinderUser createMockUser(String displayName) {
    return GameTinderUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Our internal ID
      displayName: displayName,
      avatarUrl: 'https://via.placeholder.com/64',
      ownedGameIds: ['730', '570', '1172470', '271590'],
      gamePlaytimes: {'730': 1200, '570': 300, '1172470': 60, '271590': 2400},
      steamId: '76561198000000000', // Private field, not sent to server
      steamApiKey: 'mock_api_key', // Private field, not sent to server
    );
  }

  /// Get game by ID
  static GameTinderGame? getGameById(String gameId) {
    return getMockGames().firstWhere(
      (game) => game.id == gameId,
      orElse: () => throw StateError('Game not found'),
    );
  }

  /// Get games by genre
  static List<GameTinderGame> getGamesByGenre(String genre) {
    return getMockGames().where((game) => game.genres.contains(genre)).toList();
  }

  /// Get multiplayer games only
  static List<GameTinderGame> getMultiplayerGames() {
    return getMockGames().where((game) => game.isMultiplayer).toList();
  }
}

/// Provider for mock games
final mockGamesProvider = Provider<List<GameTinderGame>>((ref) {
  return MockSteamService.getMockGames();
});

/// Provider for multiplayer games only
final multiplayerGamesProvider = Provider<List<GameTinderGame>>((ref) {
  return MockSteamService.getMultiplayerGames();
});

/// Provider for game by ID
final gameByIdProvider = Provider.family<GameTinderGame?, String>((
  ref,
  gameId,
) {
  try {
    return MockSteamService.getGameById(gameId);
  } catch (e) {
    return null;
  }
});

/// Provider for games by genre
final gamesByGenreProvider = Provider.family<List<GameTinderGame>, String>((
  ref,
  genre,
) {
  return MockSteamService.getGamesByGenre(genre);
});
