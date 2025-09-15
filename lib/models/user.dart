/// User model for Game Tinder sessions
/// Privacy-focused: Steam IDs stay local, only game data is shared
class GameTinderUser {
  final String id; // Our internal user ID (not Steam ID)
  final String displayName;
  final String avatarUrl;
  final List<String> ownedGameIds; // Games from Steam API
  final Map<String, int> gamePlaytimes; // Playtime data

  // Private fields (not sent to server)
  final String? _steamId; // Steam ID stays on device only
  final String? _steamApiKey; // API key stays on device only

  const GameTinderUser({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.ownedGameIds,
    required this.gamePlaytimes,
    String? steamId, // Optional, for local use only
    String? steamApiKey, // Optional, for local use only
  }) : _steamId = steamId,
       _steamApiKey = steamApiKey;

  // Getter for Steam ID (local use only)
  String? get steamId => _steamId;
  String? get steamApiKey => _steamApiKey;

  /// Convert to map for server (excludes private Steam data)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'ownedGameIds': ownedGameIds,
      'gamePlaytimes': gamePlaytimes,
      // Note: steamId and steamApiKey are NOT included
    };
  }

  /// Convert to map for local storage (includes Steam data)
  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'ownedGameIds': ownedGameIds,
      'gamePlaytimes': gamePlaytimes,
      'steamId': _steamId,
      'steamApiKey': _steamApiKey,
    };
  }

  factory GameTinderUser.fromMap(Map<String, dynamic> map) {
    return GameTinderUser(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      ownedGameIds: List<String>.from(map['ownedGameIds'] ?? []),
      gamePlaytimes: Map<String, int>.from(map['gamePlaytimes'] ?? {}),
      steamId: map['steamId'], // Optional, may not be present
      steamApiKey: map['steamApiKey'], // Optional, may not be present
    );
  }

  /// Create a copy with updated Steam data (for refreshing game library)
  GameTinderUser copyWithSteamData({
    List<String>? ownedGameIds,
    Map<String, int>? gamePlaytimes,
    String? avatarUrl,
  }) {
    return GameTinderUser(
      id: id,
      displayName: displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      ownedGameIds: ownedGameIds ?? this.ownedGameIds,
      gamePlaytimes: gamePlaytimes ?? this.gamePlaytimes,
      steamId: _steamId,
      steamApiKey: _steamApiKey,
    );
  }
}
