import 'package:flutter/material.dart';
import '../../models/game.dart';

/// A beautiful card widget for displaying game information
/// Similar to Tinder cards with swipe gestures
class GameCard extends StatelessWidget {
  final GameTinderGame game;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.game,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Game image background
              _buildGameImage(),

              // Gradient overlay for better text readability
              _buildGradientOverlay(),

              // Game information
              _buildGameInfo(context),

              // Swipe action indicators
              _buildSwipeIndicators(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: game.verticalImageUrl.isNotEmpty
          ? Image.network(
              game.verticalImageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              // Preload and cache images for better performance
              cacheWidth: 600, // Optimize for mobile display
              cacheHeight: 900,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingPlaceholder();
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage();
              },
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: Icon(Icons.games, size: 80, color: Colors.grey[600]),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game name
            Text(
              game.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Game description
            if (game.description.isNotEmpty)
              Text(
                game.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 12),

            // Game metadata
            _buildGameMetadata(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGameMetadata(BuildContext context) {
    return Row(
      children: [
        // Multiplayer indicator
        if (game.isMultiplayer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  'Multiplayer',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(width: 8),

        // Max players
        if (game.maxPlayers != null && game.maxPlayers! > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.group, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '${game.maxPlayers} players',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        const Spacer(),

        // Steam App ID (for debugging)
        if (game.steamAppId != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Steam: ${game.steamAppId}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSwipeIndicators() {
    return Positioned(
      top: 20,
      right: 20,
      child: Row(
        children: [
          // Dislike indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 8),

          // Like indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 8),

          // Skip indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.skip_next, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
