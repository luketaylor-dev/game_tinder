import 'package:freezed_annotation/freezed_annotation.dart';

part 'steam_game.freezed.dart';
part 'steam_game.g.dart';

/// Steam game data model from Steam API
@freezed
class SteamGame with _$SteamGame {
  const factory SteamGame({
    required int appId,
    required String name,
    String? description,
    String? imageUrl,
    String? headerImageUrl,
    @Default([]) List<String> genres,
    @Default([]) List<String> tags,
    @Default(false) bool isMultiplayer,
    int? maxPlayers,
    @Default([]) List<String> platforms,
    DateTime? releaseDate,
    int? playtimeMinutes,
    DateTime? lastPlayedAt,
  }) = _SteamGame;

  factory SteamGame.fromJson(Map<String, dynamic> json) {
    return SteamGame(
      appId: (json['appid'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Unknown Game',
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      headerImageUrl: json['headerImageUrl']?.toString(),
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      isMultiplayer: _isMultiplayerGame(json),
      maxPlayers: (json['maxPlayers'] as num?)?.toInt(),
      platforms:
          (json['platforms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'].toString())
          : null,
      playtimeMinutes: (json['playtime_forever'] as num?)?.toInt(),
      lastPlayedAt: json['rtime_last_played'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['rtime_last_played'] as num).toInt() * 1000,
            )
          : null,
    );
  }

  /// Check if a game is multiplayer based on content descriptors and other indicators
  static bool _isMultiplayerGame(Map<String, dynamic> json) {
    // Check content descriptors first (most reliable)
    final contentDescriptors =
        (json['content_descriptorids'] as List<dynamic>?)?.cast<int>() ?? [];

    // Known Steam content descriptor IDs for multiplayer:
    // 1 = Single-player (exclude if only this)
    // 2 = Multi-player
    // 3 = Co-op
    // 4 = Cross-Platform Multiplayer
    // 5 = Online PvP
    // 6 = Online Co-op
    // 7 = LAN Co-op
    // 8 = LAN PvP
    // 9 = Shared/Split Screen Co-op
    // 10 = Shared/Split Screen PvP

    final multiplayerDescriptors = [2, 3, 4, 5, 6, 7, 8, 9, 10];
    final hasMultiplayerDescriptor = contentDescriptors.any(
      (id) => multiplayerDescriptors.contains(id),
    );

    // If we have content descriptors, use them
    if (contentDescriptors.isNotEmpty) {
      return hasMultiplayerDescriptor;
    }

    // Fallback: Check for multiplayer-related genres/tags
    final genres =
        (json['genres'] as List<dynamic>?)
            ?.map((e) => e.toString().toLowerCase())
            .toList() ??
        [];
    final tags =
        (json['tags'] as List<dynamic>?)
            ?.map((e) => e.toString().toLowerCase())
            .toList() ??
        [];

    final multiplayerKeywords = [
      'multiplayer',
      'multi-player',
      'co-op',
      'coop',
      'cooperative',
      'online',
      'pvp',
      'versus',
      'competitive',
      'multiplayer online',
      'mmo',
      'massively multiplayer',
      'online co-op',
      'online multiplayer',
    ];

    final hasMultiplayerGenre = genres.any(
      (genre) => multiplayerKeywords.any((keyword) => genre.contains(keyword)),
    );
    final hasMultiplayerTag = tags.any(
      (tag) => multiplayerKeywords.any((keyword) => tag.contains(keyword)),
    );

    return hasMultiplayerGenre || hasMultiplayerTag;
  }
}

/// Steam user profile data from Steam API
@freezed
class SteamUserProfile with _$SteamUserProfile {
  const factory SteamUserProfile({
    required String steamId,
    required String displayName,
    String? avatarUrl,
    String? profileUrl,
    @Default(0) int communityVisibilityState,
    @Default(0) int profileState,
    DateTime? lastLogoff,
    @Default(false) bool commentPermission,
  }) = _SteamUserProfile;

  factory SteamUserProfile.fromJson(Map<String, dynamic> json) {
    return SteamUserProfile(
      steamId: json['steamid']?.toString() ?? '',
      displayName: json['personaname']?.toString() ?? '',
      avatarUrl: json['avatar']?.toString(),
      profileUrl: json['profileurl']?.toString(),
      communityVisibilityState:
          (json['communityvisibilitystate'] as num?)?.toInt() ?? 0,
      profileState: (json['profilestate'] as num?)?.toInt() ?? 0,
      lastLogoff: json['lastlogoff'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['lastlogoff'] as num).toInt() * 1000,
            )
          : null,
      commentPermission: (json['commentpermission'] as num?)?.toInt() == 1,
    );
  }
}

/// Steam API response wrapper
@freezed
class SteamApiResponse with _$SteamApiResponse {
  const factory SteamApiResponse({required bool success, String? error}) =
      _SteamApiResponse;

  factory SteamApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SteamApiResponseFromJson(json);
}
