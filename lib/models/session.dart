import 'user.dart';
import 'swipe_action.dart';

/// Session model for Game Tinder - temporary sessions that auto-expire
class GameTinderSession {
  final String sessionId;
  final String name;
  final List<GameTinderUser> participants;
  final Map<String, SwipeAction> swipes; // gameId_userId -> SwipeAction
  final List<String> matches; // Game IDs everyone liked
  final DateTime createdAt;
  final DateTime expiresAt;

  const GameTinderSession({
    required this.sessionId,
    required this.name,
    required this.participants,
    required this.swipes,
    required this.matches,
    required this.createdAt,
    required this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'name': name,
      'participants': participants.map((p) => p.toMap()).toList(),
      'swipes': swipes.map((k, v) => MapEntry(k, v.toMap())),
      'matches': matches,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory GameTinderSession.fromMap(Map<String, dynamic> map) {
    return GameTinderSession(
      sessionId: map['sessionId'] ?? '',
      name: map['name'] ?? '',
      participants:
          (map['participants'] as List?)
              ?.map((p) => GameTinderUser.fromMap(p))
              .toList() ??
          [],
      swipes:
          (map['swipes'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, SwipeAction.fromMap(v)),
          ) ??
          {},
      matches: List<String>.from(map['matches'] ?? []),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      expiresAt: DateTime.parse(
        map['expiresAt'] ??
            DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      ),
    );
  }

  /// Check if session is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Get mutual games for all participants
  List<String> get mutualGames {
    if (participants.isEmpty) return [];

    Set<String> mutual = Set.from(participants.first.ownedGameIds);
    for (int i = 1; i < participants.length; i++) {
      mutual = mutual.intersection(Set.from(participants[i].ownedGameIds));
    }
    return mutual.toList();
  }

  /// Get games that haven't been swiped by user
  List<String> getSwipeableGames(String userId) {
    final userSwipedGames = swipes.keys
        .where((key) => key.endsWith('_$userId'))
        .map((key) => key.split('_')[0])
        .toSet();

    return mutualGames
        .where((gameId) => !userSwipedGames.contains(gameId))
        .toList();
  }

  /// Check if everyone liked a game
  bool isGameMatched(String gameId) {
    final gameSwipes = swipes.entries
        .where((entry) => entry.key.startsWith('${gameId}_'))
        .where((entry) => entry.value.action == 'like')
        .map((entry) => entry.value.userId)
        .toSet();

    return gameSwipes.length == participants.length;
  }
}
