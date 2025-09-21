import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../services/supabase_service.dart';
import '../../screens/screens.dart';
import '../buttons/app_button.dart';
import '../cards/app_card.dart';
import '../feedback/error_message.dart';

/// Dialog for creating a new game session
class SessionCreationDialog extends ConsumerStatefulWidget {
  const SessionCreationDialog({super.key});

  @override
  ConsumerState<SessionCreationDialog> createState() =>
      _SessionCreationDialogState();
}

class _SessionCreationDialogState extends ConsumerState<SessionCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _sessionNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _sessionNameController.dispose();
    super.dispose();
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'No user found. Please go back and complete setup.';
          _isLoading = false;
        });
        return;
      }

      // First, ensure the user exists in Supabase
      await _ensureUserInSupabase(currentUser);

      final sessionNotifier = ref.read(sessionProvider.notifier);
      final sessionId = await sessionNotifier.createSession(
        _sessionNameController.text.trim(),
        [currentUser],
      );

      if (sessionId != null && mounted) {
        Navigator.of(context).pop(); // Close dialog

        // Navigate to session waiting room
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SessionWaitingRoom(sessionId: sessionId),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to create session. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  /// Ensure user exists in Supabase database
  Future<void> _ensureUserInSupabase(GameTinderUser user) async {
    try {
      // Check if user already exists
      final existingUser = await SupabaseService.from(
        'users',
      ).select().eq('id', user.id).maybeSingle();

      if (existingUser == null) {
        // Create user in Supabase
        await SupabaseService.from('users').insert({
          'id': user.id,
          'display_name': user.displayName,
          'avatar_url': user.avatarUrl,
        });
      }
    } catch (e) {
      // If user creation fails, we can still continue with session creation
      // The user might already exist or there might be a temporary issue
      print('Warning: Could not ensure user in Supabase: $e');

      // If it's an initialization error, provide more helpful feedback
      if (e.toString().contains('not initialized')) {
        throw Exception(
          'Supabase is not properly initialized. Please restart the app and ensure your .env file is configured correctly.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.group_add,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Create New Session',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                'Give your session a name so friends can easily identify it.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 20),

              // Session name input
              TextFormField(
                controller: _sessionNameController,
                decoration: InputDecoration(
                  labelText: 'Session Name',
                  hintText: 'e.g., Friday Night Gaming',
                  prefixIcon: const Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a session name';
                  }
                  if (value.trim().length < 3) {
                    return 'Session name must be at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Error message
              if (_errorMessage != null) ErrorMessage(message: _errorMessage!),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      isOutlined: true,
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Create Session',
                      icon: Icons.add,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _createSession,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog for joining an existing session
class SessionJoinDialog extends ConsumerStatefulWidget {
  const SessionJoinDialog({super.key});

  @override
  ConsumerState<SessionJoinDialog> createState() => _SessionJoinDialogState();
}

class _SessionJoinDialogState extends ConsumerState<SessionJoinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _sessionCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _sessionCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'No user found. Please go back and complete setup.';
          _isLoading = false;
        });
        return;
      }

      // First, ensure the user exists in Supabase
      await _ensureUserInSupabase(currentUser);

      final sessionNotifier = ref.read(sessionProvider.notifier);
      final success = await sessionNotifier.joinSession(
        _sessionCodeController.text.trim(),
        currentUser,
      );

      if (success && mounted) {
        Navigator.of(context).pop(); // Close dialog

        // Navigate to session waiting room
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SessionWaitingRoom(
              sessionId: _sessionCodeController.text.trim(),
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Session not found or expired. Please check the code.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  /// Ensure user exists in Supabase database
  Future<void> _ensureUserInSupabase(GameTinderUser user) async {
    try {
      // Check if user already exists
      final existingUser = await SupabaseService.from(
        'users',
      ).select().eq('id', user.id).maybeSingle();

      if (existingUser == null) {
        // Create user in Supabase
        await SupabaseService.from('users').insert({
          'id': user.id,
          'display_name': user.displayName,
          'avatar_url': user.avatarUrl,
        });
      }
    } catch (e) {
      // If user creation fails, we can still continue with session creation
      // The user might already exist or there might be a temporary issue
      print('Warning: Could not ensure user in Supabase: $e');

      // If it's an initialization error, provide more helpful feedback
      if (e.toString().contains('not initialized')) {
        throw Exception(
          'Supabase is not properly initialized. Please restart the app and ensure your .env file is configured correctly.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.group,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Join Session',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                'Enter the session code your friend shared with you.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 20),

              // Session code input
              TextFormField(
                controller: _sessionCodeController,
                decoration: InputDecoration(
                  labelText: 'Session Code',
                  hintText: 'e.g., 1234567890',
                  prefixIcon: const Icon(Icons.vpn_key),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a session code';
                  }
                  if (value.trim().length < 6) {
                    return 'Session code must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Error message
              if (_errorMessage != null) ErrorMessage(message: _errorMessage!),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      isOutlined: true,
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Join Session',
                      icon: Icons.login,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _joinSession,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Session waiting room - where users wait for others to join
class SessionWaitingRoom extends ConsumerWidget {
  final String sessionId;

  const SessionWaitingRoom({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Session: ${sessionState.currentSession?.name ?? 'Loading...'}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(sessionProvider.notifier).leaveSession();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(sessionProvider.notifier).refreshParticipants();
            },
            tooltip: 'Refresh Participants',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareSessionCode(context, sessionId),
            tooltip: 'Share Session Code',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Session info card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Session Details',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Session code
                  Row(
                    children: [
                      Text(
                        'Session Code: ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          sessionId,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontFamily: 'monospace',
                                backgroundColor: Colors.grey[100],
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copySessionCode(context, sessionId),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Expires info
                  Text(
                    'Expires: ${sessionState.currentSession?.expiresAt.toString().split('.')[0] ?? 'Unknown'}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Participants card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Participants (${sessionState.currentSession?.participants.length ?? 0})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Participants list
                  if (sessionState.currentSession?.participants.isNotEmpty ==
                      true)
                    ...sessionState.currentSession!.participants.map(
                      (participant) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: Text(
                                participant.displayName.isNotEmpty
                                    ? participant.displayName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                participant.displayName,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            if (participant.id == currentUser?.id)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  'You',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  else
                    Text(
                      'No participants yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),

            const Spacer(),

            // Start session button (only for session creator)
            if (sessionState.currentSession?.participants.isNotEmpty == true)
              AppButton(
                text: 'Start Swiping Games',
                icon: Icons.play_arrow,
                width: double.infinity,
                height: 56,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GameSwipingScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _shareSessionCode(BuildContext context, String sessionId) {
    Clipboard.setData(ClipboardData(text: sessionId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session code copied: $sessionId'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _copySessionCode(BuildContext context, String sessionId) {
    Clipboard.setData(ClipboardData(text: sessionId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session code copied: $sessionId'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
