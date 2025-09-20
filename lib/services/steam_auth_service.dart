import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Steam authentication service with improved UX
class SteamAuthService {
  static final Logger _logger = Logger();

  /// Show Steam profile page to help users find their Steam ID
  static Future<bool> showSteamProfile() async {
    try {
      _logger.i('Opening Steam profile page');

      // Open Steam profile page (user needs to be logged in)
      final steamProfileUrl = Uri.parse(
        'https://steamcommunity.com/my/profile',
      );

      if (await canLaunchUrl(steamProfileUrl)) {
        await launchUrl(steamProfileUrl, mode: LaunchMode.externalApplication);
        return true;
      } else {
        _logger.e('Could not launch Steam profile URL');
        return false;
      }
    } catch (e) {
      _logger.e('Error opening Steam profile: $e');
      return false;
    }
  }

  /// Show Steam ID finder page
  static Future<bool> showSteamIdFinder() async {
    try {
      _logger.i('Opening Steam ID finder');

      // Open Steam ID finder website
      final steamIdFinderUrl = Uri.parse('https://steamidfinder.com/');

      if (await canLaunchUrl(steamIdFinderUrl)) {
        await launchUrl(steamIdFinderUrl, mode: LaunchMode.externalApplication);
        return true;
      } else {
        _logger.e('Could not launch Steam ID finder URL');
        return false;
      }
    } catch (e) {
      _logger.e('Error opening Steam ID finder: $e');
      return false;
    }
  }

  /// Store Steam ID locally after user enters it manually
  static Future<bool> storeSteamId(String steamId) async {
    try {
      _logger.i('Storing Steam ID locally');

      // Validate Steam ID format (17 digits)
      final regex = RegExp(r'^\d{17}$');
      if (!regex.hasMatch(steamId)) {
        _logger.e('Invalid Steam ID format: $steamId');
        return false;
      }

      // Store in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_steam_id', steamId);

      _logger.i('Steam ID stored successfully');
      return true;
    } catch (e) {
      _logger.e('Error storing Steam ID: $e');
      return false;
    }
  }

  /// Get stored Steam ID
  static Future<String?> getStoredSteamId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_steam_id');
    } catch (e) {
      _logger.e('Error getting stored Steam ID: $e');
      return null;
    }
  }

  /// Clear stored Steam ID
  static Future<void> clearStoredSteamId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_steam_id');
      _logger.i('Steam ID cleared');
    } catch (e) {
      _logger.e('Error clearing Steam ID: $e');
    }
  }

  /// Check if user has a stored Steam ID
  static Future<bool> hasStoredSteamId() async {
    final steamId = await getStoredSteamId();
    return steamId != null && steamId.isNotEmpty;
  }
}
