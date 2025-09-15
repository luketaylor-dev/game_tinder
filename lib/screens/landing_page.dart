import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../components/components.dart';

/// Landing page for Game Tinder - user setup and session creation
class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(landingPageFormProvider);
    final formNotifier = ref.read(landingPageFormProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 24 : 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // App Logo/Title
                  Column(
                    children: [
                      const GradientIconContainer(
                        icon: Icons.games,
                        size: 80,
                        iconSize: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Game Tinder',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Find your next gaming session',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Welcome Card
                  AppCard(
                    child: SectionHeader(
                      title: 'Welcome to Game Tinder!',
                      subtitle:
                          'Connect with friends, discover mutual games, and find your next gaming session.',
                      icon: Icons.group_add,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // User Setup Form
                  _buildUserForm(context, formState, formNotifier),

                  const SizedBox(height: 24),

                  // Error Message
                  if (formState.errorMessage != null)
                    ErrorMessage(message: formState.errorMessage!),

                  const SizedBox(height: 24),

                  // Create User Button
                  _buildCreateButton(context, ref, formState, formNotifier),

                  const SizedBox(height: 24),

                  // Demo Button
                  _buildDemoButton(context, ref, formNotifier),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const GradientIconContainer(icon: Icons.games, size: 80, iconSize: 40),
        const SizedBox(height: 16),
        Text(
          'Game Tinder',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Find games your friends want to play',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildUserForm(
    BuildContext context,
    LandingPageFormState formState,
    LandingPageFormNotifier formNotifier,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Up Your Profile',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Display Name
          AppFormField(
            labelText: 'Display Name',
            hintText: 'How should friends see you?',
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

          const SizedBox(height: 16),

          // Steam Integration Toggle
          SwitchListTile(
            title: const Text('Connect Steam Library'),
            subtitle: const Text('Automatically find games you own'),
            value: formState.useSteamIntegration,
            onChanged: formNotifier.toggleSteamIntegration,
            secondary: const Icon(Icons.cloud_download),
          ),

          if (formState.useSteamIntegration) ...[
            const SizedBox(height: 16),

            // Steam ID
            AppFormField(
              labelText: 'Steam ID',
              hintText: '76561198000000000',
              prefixIcon: Icons.account_circle,
              helperText:
                  'Your Steam profile ID (found in your Steam profile URL)',
              initialValue: formState.steamId,
              onChanged: formNotifier.updateSteamId,
              validator: (value) {
                if (formState.useSteamIntegration &&
                    (value == null || value.trim().isEmpty)) {
                  return 'Please enter your Steam ID';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Steam API Key
            AppFormField(
              labelText: 'Steam API Key',
              hintText: 'Your Steam Web API key',
              prefixIcon: Icons.key,
              helperText: 'Get your API key from steamcommunity.com/dev/apikey',
              obscureText: true,
              initialValue: formState.steamApiKey,
              onChanged: formNotifier.updateSteamApiKey,
              validator: (value) {
                if (formState.useSteamIntegration &&
                    (value == null || value.trim().isEmpty)) {
                  return 'Please enter your Steam API key';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateButton(
    BuildContext context,
    WidgetRef ref,
    LandingPageFormState formState,
    LandingPageFormNotifier formNotifier,
  ) {
    return AppButton(
      text: 'Continue',
      isLoading: formState.isLoading,
      onPressed: formState.isLoading
          ? null
          : () => _createUser(context, ref, formState, formNotifier),
    );
  }

  Widget _buildDemoButton(
    BuildContext context,
    WidgetRef ref,
    LandingPageFormNotifier formNotifier,
  ) {
    return AppButton(
      text: 'Try Demo Mode',
      isOutlined: true,
      onPressed: () {
        formNotifier.setDemoMode();
        _createUser(context, ref, formNotifier.state, formNotifier);
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

    if (formState.useSteamIntegration &&
        (formState.steamId.trim().isEmpty ||
            formState.steamApiKey.trim().isEmpty)) {
      formNotifier.setError('Please enter both Steam ID and API key');
      return;
    }

    formNotifier.setLoading(true);
    formNotifier.clearError();

    try {
      GameTinderUser user;

      if (formState.useSteamIntegration &&
          formState.steamId.isNotEmpty &&
          formState.steamApiKey.isNotEmpty) {
        // Create user with Steam integration
        user =
            await SteamApiService.fetchUserProfile(
              steamId: formState.steamId.trim(),
              steamApiKey: formState.steamApiKey.trim(),
              displayName: formState.displayName.trim(),
            ) ??
            MockSteamService.createMockUser(formState.displayName.trim());
      } else {
        // Create user with mock data
        user = MockSteamService.createMockUser(formState.displayName.trim());
      }

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

    // Debug: Print current user state
    print(
      'SessionCreationPage - Current user: ${currentUser?.displayName ?? 'null'}',
    );

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

            const SizedBox(height: 16),

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
                  const SizedBox(height: 16),
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

            const SizedBox(height: 16),

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
                  const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}
