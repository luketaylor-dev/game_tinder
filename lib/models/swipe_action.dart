/// Swipe action model for Game Tinder sessions
class SwipeAction {
  final String gameId;
  final String userId;
  final String action; // 'like', 'dislike', 'skip'
  final DateTime timestamp;

  const SwipeAction({
    required this.gameId,
    required this.userId,
    required this.action,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'userId': userId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SwipeAction.fromMap(Map<String, dynamic> map) {
    return SwipeAction(
      gameId: map['gameId'] ?? '',
      userId: map['userId'] ?? '',
      action: map['action'] ?? '',
      timestamp: DateTime.parse(
        map['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
