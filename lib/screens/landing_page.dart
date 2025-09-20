import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../components/components.dart';
import '../services/steam_auth_service.dart';

/// Landing page for Game Tinder - user setup and session creation
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  bool _hasSteamId = false;

  @override
  void initState() {
    super.initState();
    _checkSteamId();
  }

  Future<void> _checkSteamId() async {
    final hasSteamId = await SteamAuthService.hasStoredSteamId();
    if (mounted) {
      setState(() {
        _hasSteamId = hasSteamId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(landingPageFormProvider);
    final formNotifier = ref.read(landingPageFormProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const SteamApiTestDialog(),
          );
        },
        tooltip: 'Test Steam API',
        child: const Icon(Icons.bug_report),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 24 : 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Logo/Title
                  Column(
                    children: [
                      const GradientIconContainer(
                        icon: Icons.games,
                        size: 60,
                        iconSize: 30,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Game Tinder',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Connect with friends, discover mutual games, and find your next gaming session.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // User Setup Form
                  _buildUserForm(context, formState, formNotifier),

                  const SizedBox(height: 12),

                  // Error Message
                  if (formState.errorMessage != null)
                    ErrorMessage(message: formState.errorMessage!),

                  const SizedBox(height: 12),

                  // Create User Button (only enabled if Steam ID is saved)
                  _buildCreateButton(context, ref, formState, formNotifier),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserForm(
    BuildContext context,
    LandingPageFormState formState,
    LandingPageFormNotifier formNotifier,
  ) {
    return Column(
      children: [
        // Display Name Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Display Name',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              AppFormField(
                labelText: 'How should friends see you?',
                hintText: 'Enter your display name',
                prefixIcon: Icons.person,
                initialValue: formState.displayName,
                onChanged: formNotifier.updateDisplayName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a display name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Steam Authentication Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.games,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Steam Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_hasSteamId)
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Connected',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SteamAuthWidget(
                onSteamIdSaved: () {
                  _checkSteamId();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(
    BuildContext context,
    WidgetRef ref,
    LandingPageFormState formState,
    LandingPageFormNotifier formNotifier,
  ) {
    return FutureBuilder<bool>(
      future: SteamAuthService.hasStoredSteamId(),
      builder: (context, snapshot) {
        final hasSteamId = snapshot.data ?? false;
        final canContinue =
            !formState.isLoading &&
            formState.displayName.trim().isNotEmpty &&
            hasSteamId;

        String buttonText = 'Continue';
        if (!hasSteamId) {
          buttonText = 'Save Steam ID to Continue';
        }

        return AppButton(
          text: buttonText,
          isLoading: formState.isLoading,
          onPressed: canContinue
              ? () => _createUser(context, ref, formState, formNotifier)
              : null,
        );
      },
    );
  }

  Future<void> _createUser(
    BuildContext context,
    WidgetRef ref,
    LandingPageFormState formState,
    LandingPageFormNotifier formNotifier,
  ) async {
    // Basic validation
    if (formState.displayName.trim().isEmpty) {
      formNotifier.setError('Please enter a display name');
      return;
    }

    // Steam authentication is now handled by SteamAuthWidget

    formNotifier.setLoading(true);
    formNotifier.clearError();

    try {
      GameTinderUser user;

      // Get stored Steam ID
      final steamId = await SteamAuthService.getStoredSteamId();
      if (steamId == null) {
        formNotifier.setError('Steam ID is required to continue');
        return;
      }

      // Create user with Steam ID
      user = MockSteamService.createMockUser(formState.displayName.trim());

      // Set current user
      ref.read(sessionProvider.notifier).setCurrentUser(user);

      // Navigate to session creation
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SessionCreationPage()),
        );
      }
    } catch (e) {
      formNotifier.setError(e.toString());
    } finally {
      formNotifier.setLoading(false);
    }
  }
}

/// Session creation page (placeholder for now)
class SessionCreationPage extends ConsumerWidget {
  const SessionCreationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to landing page
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome back card
            AppCard(
              child: Row(
                children: [
                  UserAvatar(
                    avatarUrl: currentUser?.avatarUrl,
                    displayName: currentUser?.displayName,
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser != null
                              ? 'Welcome back, ${currentUser.displayName}!'
                              : 'Welcome to Game Tinder!',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ready to find games with friends?',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Session creation options
            Text(
              'Create a New Session',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Create session card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.group_add,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Start a Game Session',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Create a session and invite friends to swipe on games together.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: 'Create Session',
                    icon: Icons.add,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Session creation coming soon!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Join session card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Join Existing Session',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter a session code to join friends who already started a session.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: 'Join Session',
                    icon: Icons.login,
                    isOutlined: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Session joining coming soon!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Back to setup button
            Center(
              child: AppButton(
                text: 'Back to Setup',
                icon: Icons.settings,
                isOutlined: true,
                width: 200,
                height: 48,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            // Steam API test buttons (always visible for testing)
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  text: 'Test Steam API',
                  icon: Icons.bug_report,
                  isOutlined: true,
                  width: 150,
                  height: 48,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const SteamApiTestDialog(),
                    );
                  },
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: 'Quick Test',
                  icon: Icons.speed,
                  isOutlined: true,
                  width: 150,
                  height: 48,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const QuickSteamTestWidget(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
