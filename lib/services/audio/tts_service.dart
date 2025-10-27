import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for pronunciation support
/// Provides methods to speak German words and phrases with proper pronunciation
class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  /// Initialize the TTS service with default settings
  static Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      // Set language to German
      await _flutterTts.setLanguage('de-DE');

      // Set speech rate (0.0 to 1.0, default is usually 0.5)
      await _flutterTts.setSpeechRate(0.5);

      // Set volume (0.0 to 1.0)
      await _flutterTts.setVolume(1.0);

      // Set pitch (0.5 to 2.0, default is 1.0)
      await _flutterTts.setPitch(1.0);

      // Platform-specific settings
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _flutterTts.setSharedInstance(true);
        await _flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }

      _isInitialized = true;
      debugPrint('TTSService initialized successfully');
    } catch (e) {
      debugPrint('TTSService initialization error: $e');
      // Don't rethrow - TTS is a nice-to-have feature
    }
  }

  /// Speak the given text in German
  static Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      await _initialize();
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTSService speak error: $e');
    }
  }

  /// Set the language for text-to-speech
  /// Common values: 'de-DE' (German), 'en-US' (English), 'ru-RU' (Russian)
  static Future<void> setLanguage(String language) async {
    try {
      await _initialize();
      await _flutterTts.setLanguage(language);
      debugPrint('TTSService language set to: $language');
    } catch (e) {
      debugPrint('TTSService setLanguage error: $e');
    }
  }

  /// Stop any ongoing speech
  static Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('TTSService stop error: $e');
    }
  }

  /// Set the speech rate (0.0 to 1.0)
  /// Lower values = slower speech, higher values = faster speech
  static Future<void> setSpeechRate(double rate) async {
    try {
      await _initialize();
      // Clamp rate between 0.0 and 1.0
      final clampedRate = rate.clamp(0.0, 1.0);
      await _flutterTts.setSpeechRate(clampedRate);
      debugPrint('TTSService speech rate set to: $clampedRate');
    } catch (e) {
      debugPrint('TTSService setSpeechRate error: $e');
    }
  }

  /// Set the volume (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    try {
      await _initialize();
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _flutterTts.setVolume(clampedVolume);
      debugPrint('TTSService volume set to: $clampedVolume');
    } catch (e) {
      debugPrint('TTSService setVolume error: $e');
    }
  }

  /// Set the pitch (0.5 to 2.0, default is 1.0)
  static Future<void> setPitch(double pitch) async {
    try {
      await _initialize();
      final clampedPitch = pitch.clamp(0.5, 2.0);
      await _flutterTts.setPitch(clampedPitch);
      debugPrint('TTSService pitch set to: $clampedPitch');
    } catch (e) {
      debugPrint('TTSService setPitch error: $e');
    }
  }

  /// Get available languages on the device
  static Future<List<dynamic>> getAvailableLanguages() async {
    try {
      await _initialize();
      return await _flutterTts.getLanguages;
    } catch (e) {
      debugPrint('TTSService getAvailableLanguages error: $e');
      return [];
    }
  }

  /// Check if a specific language is available
  static Future<bool> isLanguageAvailable(String language) async {
    try {
      final languages = await getAvailableLanguages();
      return languages.contains(language);
    } catch (e) {
      debugPrint('TTSService isLanguageAvailable error: $e');
      return false;
    }
  }
}
