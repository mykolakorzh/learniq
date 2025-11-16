import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learniq/services/progress_service.dart';
import 'package:learniq/models/learning_session.dart';

void main() {
  group('ProgressService', () {
    setUp(() async {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      await ProgressService.clearAllProgress();
    });

    test('getProgress returns default values for new topic', () async {
      final progress = await ProgressService.getProgress('new_topic');
      expect(progress.lastAccuracy, 0.0);
      expect(progress.mistakeIds, isEmpty);
    });

    test('setAccuracy and getProgress work correctly', () async {
      await ProgressService.setAccuracy('test_topic', 0.85);
      final progress = await ProgressService.getProgress('test_topic');
      expect(progress.lastAccuracy, 0.85);
    });

    test('setAccuracy clamps values to 0.0-1.0', () async {
      await ProgressService.setAccuracy('test_topic', 1.5);
      final progress1 = await ProgressService.getProgress('test_topic');
      expect(progress1.lastAccuracy, 1.0);

      await ProgressService.setAccuracy('test_topic', -0.5);
      final progress2 = await ProgressService.getProgress('test_topic');
      expect(progress2.lastAccuracy, 0.0);
    });

    test('setMistakes and getProgress work correctly', () async {
      final mistakeIds = ['card_1', 'card_2', 'card_3'];
      await ProgressService.setMistakes('test_topic', mistakeIds);
      final progress = await ProgressService.getProgress('test_topic');
      expect(progress.mistakeIds, mistakeIds);
    });

    test('clearMistakes removes mistakes for topic', () async {
      await ProgressService.setMistakes('test_topic', ['card_1', 'card_2']);
      await ProgressService.clearMistakes('test_topic');
      final progress = await ProgressService.getProgress('test_topic');
      expect(progress.mistakeIds, isEmpty);
    });

    test('recordSession saves learning session', () async {
      final session = LearningSession(
        id: 'test_session_1',
        topicId: 'test_topic',
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        endTime: DateTime.now(),
        cardsReviewed: 20,
        correctAnswers: 18,
        averageResponseTime: 3.0,
      );

      await ProgressService.recordSession(session);
      final sessions = await ProgressService.getAllSessions();
      expect(sessions.length, 1);
      expect(sessions.first.topicId, 'test_topic');
      expect(sessions.first.cardsReviewed, 20);
    });

    test('getTopicSessions returns only sessions for specific topic', () async {
      await ProgressService.recordSession(LearningSession(
        id: 'session_1',
        topicId: 'topic_1',
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        endTime: DateTime.now(),
        cardsReviewed: 10,
        correctAnswers: 8,
        averageResponseTime: 3.0,
      ));

      await ProgressService.recordSession(LearningSession(
        id: 'session_2',
        topicId: 'topic_2',
        startTime: DateTime.now().subtract(const Duration(minutes: 5)),
        endTime: DateTime.now(),
        cardsReviewed: 15,
        correctAnswers: 12,
        averageResponseTime: 2.5,
      ));

      final topic1Sessions = await ProgressService.getTopicSessions('topic_1');
      expect(topic1Sessions.length, 1);
      expect(topic1Sessions.first.topicId, 'topic_1');
    });

    test('getTodaySessions returns only today sessions', () async {
      // Today's session
      await ProgressService.recordSession(LearningSession(
        id: 'session_today',
        topicId: 'test_topic',
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        endTime: DateTime.now(),
        cardsReviewed: 10,
        correctAnswers: 8,
        averageResponseTime: 3.0,
      ));

      // Yesterday's session (should not be included)
      await ProgressService.recordSession(LearningSession(
        id: 'session_yesterday',
        topicId: 'test_topic',
        startTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        endTime: DateTime.now().subtract(const Duration(days: 1)),
        cardsReviewed: 5,
        correctAnswers: 4,
        averageResponseTime: 2.5,
      ));

      final todaySessions = await ProgressService.getTodaySessions();
      expect(todaySessions.length, 1);
    });

    test('getRecentSessions returns sessions from last N days', () async {
      final now = DateTime.now();
      
      // 2 days ago
      await ProgressService.recordSession(LearningSession(
        id: 'session_2d',
        topicId: 'test_topic',
        startTime: now.subtract(const Duration(days: 2, hours: 1)),
        endTime: now.subtract(const Duration(days: 2)),
        cardsReviewed: 5,
        correctAnswers: 4,
        averageResponseTime: 2.5,
      ));

      // 1 day ago
      await ProgressService.recordSession(LearningSession(
        id: 'session_1d',
        topicId: 'test_topic',
        startTime: now.subtract(const Duration(days: 1, hours: 1)),
        endTime: now.subtract(const Duration(days: 1)),
        cardsReviewed: 10,
        correctAnswers: 8,
        averageResponseTime: 3.0,
      ));

      // Today
      await ProgressService.recordSession(LearningSession(
        id: 'session_today',
        topicId: 'test_topic',
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now,
        cardsReviewed: 15,
        correctAnswers: 12,
        averageResponseTime: 3.5,
      ));

      final recentSessions = await ProgressService.getRecentSessions(2);
      expect(recentSessions.length, 2); // Today and 1 day ago
    });

    test('clearAllProgress removes all progress data', () async {
      await ProgressService.setAccuracy('topic_1', 0.8);
      await ProgressService.setMistakes('topic_1', ['card_1']);
      await ProgressService.setAccuracy('topic_2', 0.9);

      await ProgressService.clearAllProgress();

      final progress1 = await ProgressService.getProgress('topic_1');
      final progress2 = await ProgressService.getProgress('topic_2');

      expect(progress1.lastAccuracy, 0.0);
      expect(progress1.mistakeIds, isEmpty);
      expect(progress2.lastAccuracy, 0.0);
    });
  });
}

