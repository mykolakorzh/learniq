import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TopicProgress {
  TopicProgress({required this.lastAccuracy, required this.mistakeIds});

  final double lastAccuracy; // 0.0..1.0
  final List<String> mistakeIds;
}

class ProgressService {
  static String _accuracyKey(String topicId) => 'progress_accuracy_$topicId';
  static String _mistakesKey(String topicId) => 'progress_mistakes_$topicId';

  static Future<TopicProgress> getProgress(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    final acc = prefs.getDouble(_accuracyKey(topicId)) ?? 0.0;
    final raw = prefs.getString(_mistakesKey(topicId));
    final ids = raw == null ? <String>[] : List<String>.from(jsonDecode(raw));
    return TopicProgress(lastAccuracy: acc, mistakeIds: ids);
  }

  static Future<void> setAccuracy(String topicId, double accuracy01) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_accuracyKey(topicId), accuracy01.clamp(0.0, 1.0));
  }

  static Future<void> setMistakes(String topicId, List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mistakesKey(topicId), jsonEncode(ids));
  }

  static Future<void> clearMistakes(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mistakesKey(topicId));
  }

  /// Clear all progress data for all topics
  static Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    // Remove all keys that start with 'progress_'
    for (final key in keys) {
      if (key.startsWith('progress_')) {
        await prefs.remove(key);
      }
    }
  }
}


