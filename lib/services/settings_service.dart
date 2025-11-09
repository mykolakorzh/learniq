import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _soundEffectsKey = 'settings_sound_effects';
  static const String _hapticFeedbackKey = 'settings_haptic_feedback';
  static const String _languageKey = 'settings_language';
  static const String _ttsEnabledKey = 'settings_tts_enabled';

  // Get settings
  static Future<bool> getSoundEffectsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEffectsKey) ?? true; // Enabled by default
  }

  static Future<bool> getHapticFeedbackEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticFeedbackKey) ?? true; // Enabled by default
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'ru'; // Russian by default
  }

  static Future<bool> getTTSEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_ttsEnabledKey) ?? true; // Enabled by default
  }

  // Set settings
  static Future<void> setSoundEffectsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEffectsKey, enabled);
  }

  static Future<void> setHapticFeedbackEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticFeedbackKey, enabled);
  }

  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Future<void> setTTSEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ttsEnabledKey, enabled);
  }

  // Clear all settings
  static Future<void> resetToDefaults() async {
    await setSoundEffectsEnabled(true);
    await setHapticFeedbackEnabled(true);
    await setLanguage('ru');
    await setTTSEnabled(true);
  }
}
