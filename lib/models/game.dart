/// Game model for Game Tinder sessions
class GameTinderGame {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> genres;
  final bool isMultiplayer;

  const GameTinderGame({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.genres,
    required this.isMultiplayer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'genres': genres,
      'isMultiplayer': isMultiplayer,
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
    );
  }
}
