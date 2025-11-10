import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learning_session.dart';

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

  // ==================== Learning Session Tracking ====================

  static const String _sessionsKey = 'learning_sessions';

  /// Record a completed learning session
  static Future<void> recordSession(LearningSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getAllSessions();
    sessions.add(session);

    // Keep only last 100 sessions to prevent storage bloat
    final recentSessions = sessions.length > 100 ? sessions.sublist(sessions.length - 100) : sessions;

    final jsonList = recentSessions.map((s) => s.toJson()).toList();
    await prefs.setString(_sessionsKey, jsonEncode(jsonList));
  }

  /// Get all learning sessions
  static Future<List<LearningSession>> getAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_sessionsKey);

    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => LearningSession.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get sessions for a specific topic
  static Future<List<LearningSession>> getTopicSessions(String topicId) async {
    final allSessions = await getAllSessions();
    return allSessions.where((s) => s.topicId == topicId).toList();
  }

  /// Get sessions from the last N days
  static Future<List<LearningSession>> getRecentSessions(int days) async {
    final allSessions = await getAllSessions();
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return allSessions.where((s) => s.endTime.isAfter(cutoffDate)).toList();
  }

  /// Get today's sessions
  static Future<List<LearningSession>> getTodaySessions() async {
    final allSessions = await getAllSessions();
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return allSessions.where((s) => s.endTime.isAfter(startOfDay)).toList();
  }

  /// Get statistics for a time period
  static Future<PeriodStats> getPeriodStats(int days) async {
    final sessions = await getRecentSessions(days);
    return PeriodStats.fromSessions(sessions);
  }

  /// Get statistics for a specific topic
  static Future<PeriodStats> getTopicPeriodStats(String topicId, int days) async {
    final allSessions = await getRecentSessions(days);
    final topicSessions = allSessions.where((s) => s.topicId == topicId).toList();
    return PeriodStats.fromSessions(topicSessions);
  }
}


