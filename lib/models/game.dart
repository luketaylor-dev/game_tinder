/// Game model for Game Tinder sessions
class GameTinderGame {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> genres;
  final bool isMultiplayer;
  final int? maxPlayers;
  final int? steamAppId;
  final List<String> platforms;
  final DateTime? releaseDate;

  const GameTinderGame({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.genres,
    required this.isMultiplayer,
    this.maxPlayers,
    this.steamAppId,
    this.platforms = const [],
    this.releaseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'genres': genres,
      'isMultiplayer': isMultiplayer,
      'maxPlayers': maxPlayers,
      'steamAppId': steamAppId,
      'platforms': platforms,
      'releaseDate': releaseDate?.toIso8601String(),
    };
  }

  factory GameTinderGame.fromMap(Map<String, dynamic> map) {
    return GameTinderGame(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      genres: List<String>.from(map['genres'] ?? []),
      isMultiplayer: map['isMultiplayer'] ?? false,
      maxPlayers: map['maxPlayers'],
      steamAppId: map['steamAppId'],
      platforms: List<String>.from(map['platforms'] ?? []),
      releaseDate: map['releaseDate'] != null
          ? DateTime.parse(map['releaseDate'])
          : null,
    );
  }

  /// Create a copy with updated fields
  GameTinderGame copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? genres,
    bool? isMultiplayer,
    int? maxPlayers,
    int? steamAppId,
    List<String>? platforms,
    DateTime? releaseDate,
  }) {
    return GameTinderGame(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      genres: genres ?? this.genres,
      isMultiplayer: isMultiplayer ?? this.isMultiplayer,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      steamAppId: steamAppId ?? this.steamAppId,
      platforms: platforms ?? this.platforms,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  /// Get vertical capsule image URL (better for mobile)
  String get verticalImageUrl {
    if (steamAppId != null) {
      return 'https://cdn.akamai.steamstatic.com/steam/apps/$steamAppId/library_600x900_2x.jpg';
    }
    return imageUrl; // Fallback to regular image
  }
}
