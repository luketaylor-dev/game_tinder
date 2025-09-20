import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/steam_provider.dart';
import '../../services/steam_api_service.dart';
import '../buttons/app_button.dart';
import '../cards/app_card.dart';
import '../feedback/error_message.dart';
import '../forms/app_form_field.dart';
import '../layout/section_header.dart';

/// Steam authentication form widget
class SteamAuthForm extends ConsumerStatefulWidget {
  const SteamAuthForm({super.key});

  @override
  ConsumerState<SteamAuthForm> createState() => _SteamAuthFormState();
}

class _SteamAuthFormState extends ConsumerState<SteamAuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _steamIdController = TextEditingController();
  final _steamApiKeyController = TextEditingController();
  bool _obscureApiKey = true;

  @override
  void dispose() {
    _steamIdController.dispose();
    _steamApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steamAuth = ref.watch(steamAuthProvider);

    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Steam Authentication',
              subtitle: 'Connect your Steam account to sync your game library',
            ),
            const SizedBox(height: 24),

            // Steam ID field
            AppFormField(
              labelText: 'Steam ID',
              hintText: 'Enter your 17-digit Steam ID',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Steam ID';
                }
                if (!SteamApiService.isValidSteamId(value)) {
                  return 'Steam ID must be 17 digits';
                }
                return null;
              },
              onChanged: (value) => _steamIdController.text = value,
            ),
            const SizedBox(height: 16),

            // Steam API Key field
            AppFormField(
              labelText: 'Steam API Key',
              hintText: 'Enter your Steam Web API key',
              obscureText: _obscureApiKey,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Steam API key';
                }
                if (value.length < 10) {
                  return 'API key seems too short';
                }
                return null;
              },
              onChanged: (value) => _steamApiKeyController.text = value,
            ),
            const SizedBox(height: 16),

            // Help text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to get your Steam credentials:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Steam ID: Go to your Steam profile and copy the numbers from the URL\n'
                    '2. API Key: Get a free key from steamcommunity.com/dev/apikey',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Error message
            if (steamAuth.error != null) ...[
              ErrorMessage(message: steamAuth.error!),
              const SizedBox(height: 16),
            ],

            // Authenticate button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Connect Steam Account',
                onPressed: steamAuth.isLoading ? null : _authenticate,
                isLoading: steamAuth.isLoading,
              ),
            ),

            // Success message
            if (steamAuth.isAuthenticated) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Connected as ${steamAuth.displayName}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(steamAuthProvider.notifier)
        .authenticate(
          steamId: _steamIdController.text.trim(),
          steamApiKey: _steamApiKeyController.text.trim(),
        );
  }
}
