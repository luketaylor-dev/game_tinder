import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/steam_auth_service.dart';
import '../buttons/app_button.dart';

/// Steam authentication widget for the landing page
class SteamAuthWidget extends ConsumerStatefulWidget {
  final VoidCallback? onSteamIdSaved;

  const SteamAuthWidget({super.key, this.onSteamIdSaved});

  @override
  ConsumerState<SteamAuthWidget> createState() => _SteamAuthWidgetState();
}

class _SteamAuthWidgetState extends ConsumerState<SteamAuthWidget> {
  final _steamIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _steamIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Steam ID input field
        TextFormField(
          controller: _steamIdController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Steam ID',
            hintText: '76561198000000001',
            helperText: 'Your 17-digit Steam ID',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // Optional: Add real-time validation
          },
        ),

        const SizedBox(height: 8),

        // Help text with link
        Row(
          children: [
            Text(
              'Need help finding your Steam ID? ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            GestureDetector(
              onTap: _openSteamIdFinder,
              child: Text(
                'Find it here',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Save Steam ID button
        AppButton(
          text: 'Save Steam ID',
          icon: Icons.save,
          width: double.infinity,
          height: 48,
          onPressed: _isLoading ? null : _saveSteamId,
        ),
      ],
    );
  }

  Future<void> _openSteamIdFinder() async {
    try {
      final success = await SteamAuthService.showSteamIdFinder();

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open Steam ID finder'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveSteamId() async {
    final steamId = _steamIdController.text.trim();

    if (steamId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Steam ID')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Store Steam ID using the service
      final success = await SteamAuthService.storeSteamId(steamId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Steam ID saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Notify parent that Steam ID was saved
          await Future.delayed(const Duration(milliseconds: 100));
          widget.onSteamIdSaved?.call();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Steam ID format. Must be 17 digits.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
