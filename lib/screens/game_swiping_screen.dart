import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../models/game.dart';
import '../../providers/providers.dart';
import '../../config/environment_config.dart';
import '../../services/steam_api_service.dart';
import '../components/components.dart';

/// Main screen for swiping through games
/// Similar to Tinder's main swiping interface
class GameSwipingScreen extends ConsumerStatefulWidget {
  const GameSwipingScreen({super.key});

  @override
  ConsumerState<GameSwipingScreen> createState() => _GameSwipingScreenState();
}

class _GameSwipingScreenState extends ConsumerState<GameSwipingScreen> {
  final PageController _pageController = PageController();
  final Logger _logger = Logger();
  int _currentIndex = 0;
  List<GameTinderGame> _games = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();

    // Listen to page changes to preload images
    _pageController.addListener(() {
      final newIndex = _pageController.page?.round() ?? 0;
      if (newIndex != _currentIndex) {
        _currentIndex = newIndex;
        _preloadImages();
      }
    });
  }

  /// Preload images for the next 10 games to improve performance
  void _preloadImages() {
    if (_games.isEmpty) return;

    final startIndex = _currentIndex;
    final endIndex = (startIndex + 10).clamp(0, _games.length);

    for (int i = startIndex; i < endIndex; i++) {
      final game = _games[i];
      if (game.verticalImageUrl.isNotEmpty) {
        // Preload the image
        precacheImage(NetworkImage(game.verticalImageUrl), context).catchError((
          error,
        ) {
          _logger.w('Failed to preload image for ${game.name}: $error');
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    try {
      _logger.i('Loading games from Steam API...');

      // Get the current session to access user's Steam data
      final sessionState = ref.read(sessionProvider);
      if (sessionState.currentSession?.participants.isEmpty == true) {
        _logger.w('No participants in session, using mock games');
        setState(() {
          _games = _getMockGames();
          _isLoading = false;
        });
        return;
      }

      // Get the current user (session host or participant)
      final currentUser = sessionState.currentSession?.participants.first;
      if (currentUser == null) {
        _logger.w('No current user found, using mock games');
        setState(() {
          _games = _getMockGames();
          _isLoading = false;
        });
        return;
      }

      _logger.i('Current user: ${currentUser.displayName}');
      _logger.i('Steam ID: ${currentUser.steamId}');
      _logger.i(
        'Steam API Key: ${EnvironmentConfig.steamApiKey.isNotEmpty ? "Present" : "Missing"}',
      );

      if (currentUser.steamId == null) {
        _logger.w('User has no Steam ID, using mock games');
        setState(() {
          _games = _getMockGames();
          _isLoading = false;
        });
        return;
      }

      // Load user's Steam games
      _logger.i('Calling Steam API with Steam ID: ${currentUser.steamId}');
      final response = await SteamApiService.fetchUserGames(
        steamId: currentUser.steamId!,
        steamApiKey: EnvironmentConfig.steamApiKey,
      );

      _logger.i('Steam API response success: ${response.success}');
      if (!response.success) {
        _logger.e('Steam API error: ${response.error}');
      } else {
        _logger.i('Steam API returned ${response.data?.length ?? 0} games');
      }

      if (!response.success || response.data == null) {
        _logger.w('Failed to load Steam games: ${response.error}');
        setState(() {
          _games = _getMockGames();
          _isLoading = false;
        });
        return;
      }

      final steamGames = response.data!;

      _logger.i('Total games from Steam API: ${steamGames.length}');
      _logger.i(
        'First few games: ${steamGames.take(5).map((g) => '${g.name} (multiplayer: ${g.isMultiplayer})').toList()}',
      );

      // Filter for multiplayer games and convert to GameTinderGame
      final multiplayerGames = steamGames
          .where((game) => game.isMultiplayer)
          .map(
            (steamGame) => GameTinderGame(
              id: steamGame.appId.toString(),
              name: steamGame.name,
              description: steamGame.description ?? '',
              imageUrl: steamGame.imageUrl ?? '',
              genres: steamGame.genres,
              isMultiplayer: steamGame.isMultiplayer,
              maxPlayers: steamGame.maxPlayers,
              steamAppId: steamGame.appId,
              platforms: steamGame.platforms,
              releaseDate: steamGame.releaseDate,
            ),
          )
          .toList();

      _logger.i('Loaded ${multiplayerGames.length} multiplayer games');

      setState(() {
        _games = multiplayerGames.isNotEmpty
            ? multiplayerGames
            : _getMockGames();
        _isLoading = false;
      });

      // Preload images after games are loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _preloadImages();
      });
    } catch (e) {
      _logger.e('Error loading games: $e');
      // Fallback to mock games on error
      setState(() {
        _games = _getMockGames();
        _isLoading = false;
      });
    }
  }

  List<GameTinderGame> _getMockGames() {
    return [
      GameTinderGame(
        id: '1',
        name: 'Counter-Strike 2',
        description:
            'The world\'s premier competitive FPS game. Counter-Strike 2 is the largest technical leap forward in Counter-Strike\'s history.',
        imageUrl:
            'https://cdn.akamai.steamstatic.com/steam/apps/730/library_600x900_2x.jpg',
        genres: ['Action', 'FPS', 'Multiplayer'],
        isMultiplayer: true,
        maxPlayers: 32,
        steamAppId: 730,
        platforms: ['Windows', 'Linux', 'macOS'],
      ),
      GameTinderGame(
        id: '2',
        name: 'Dota 2',
        description:
            'Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes.',
        imageUrl:
            'https://cdn.akamai.steamstatic.com/steam/apps/570/library_600x900_2x.jpg',
        genres: ['Action', 'Strategy', 'MOBA'],
        isMultiplayer: true,
        maxPlayers: 10,
        steamAppId: 570,
        platforms: ['Windows', 'Linux', 'macOS'],
      ),
      GameTinderGame(
        id: '3',
        name: 'Apex Legends',
        description:
            'Apex Legends is the award-winning, free-to-play Hero Shooter from Respawn Entertainment.',
        imageUrl:
            'https://cdn.akamai.steamstatic.com/steam/apps/1172470/library_600x900_2x.jpg',
        genres: ['Action', 'FPS', 'Battle Royale'],
        isMultiplayer: true,
        maxPlayers: 60,
        steamAppId: 1172470,
        platforms: ['Windows', 'PlayStation', 'Xbox', 'Nintendo Switch'],
      ),
      GameTinderGame(
        id: '4',
        name: 'Grand Theft Auto V',
        description:
            'Grand Theft Auto V for PC offers players the option to explore the award-winning world of Los Santos.',
        imageUrl:
            'https://cdn.akamai.steamstatic.com/steam/apps/271590/library_600x900_2x.jpg',
        genres: ['Action', 'Adventure', 'Open World'],
        isMultiplayer: true,
        maxPlayers: 30,
        steamAppId: 271590,
        platforms: ['Windows', 'PlayStation', 'Xbox'],
      ),
    ];
  }

  void _onSwipeLeft(GameTinderGame game) {
    _logger.d('Disliked game: ${game.name}');
    _nextGame();
  }

  void _onSwipeRight(GameTinderGame game) {
    _logger.d('Liked game: ${game.name}');
    // TODO: Save like to database
    _nextGame();
  }

  void _onSwipeUp(GameTinderGame game) {
    _logger.d('Skipped game: ${game.name}');
    _nextGame();
  }

  void _onTapGame(GameTinderGame game) {
    _logger.d('Tapped game: ${game.name}');
    // Could show game details dialog or navigate to game info
  }

  void _nextGame() {
    if (_currentIndex < _games.length - 1) {
      _currentIndex++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showNoMoreGamesDialog();
    }
  }

  void _showNoMoreGamesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No More Games'),
        content: const Text('You\'ve swiped through all available games!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Load more games or show results
            },
            child: const Text('View Results'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 0;
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_games.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Game Swiping'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.games, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No Games Available',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Check back later for more games!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Swiping'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Text(
                '${_currentIndex + 1} / ${_games.length}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _games.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),

          // Game cards with improved performance
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                // Preload images when page changes
                _preloadImages();
              },
              itemCount: _games.length,
              // Reduce jitter by using more stable physics
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final game = _games[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SwipeableGameCard(
                    key: ValueKey(game.id), // Stable key to prevent rebuilds
                    game: game,
                    onSwipeLeft: () => _onSwipeLeft(game),
                    onSwipeRight: () => _onSwipeRight(game),
                    onSwipeUp: () => _onSwipeUp(game),
                    onTap: () => _onTapGame(game),
                  ),
                );
              },
            ),
          ),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_currentIndex >= _games.length) return const SizedBox.shrink();

    final currentGame = _games[_currentIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Dislike button
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            onPressed: () => _onSwipeLeft(currentGame),
          ),

          // Skip button
          _buildActionButton(
            icon: Icons.skip_next,
            color: Colors.orange,
            onPressed: () => _onSwipeUp(currentGame),
          ),

          // Like button
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.green,
            onPressed: () => _onSwipeRight(currentGame),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        iconSize: 32,
        onPressed: onPressed,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
