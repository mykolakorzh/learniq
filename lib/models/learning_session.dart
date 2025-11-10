/// Model for tracking individual learning sessions
///
/// A learning session represents a single study period where the user
/// reviews multiple cards. Tracking sessions helps:
/// - Show learning history and patterns
/// - Calculate study time and efficiency
/// - Identify optimal study times
/// - Generate motivational insights
class LearningSession {
  LearningSession({
    required this.id,
    required this.topicId,
    required this.startTime,
    required this.endTime,
    required this.cardsReviewed,
    required this.correctAnswers,
    required this.averageResponseTime,
  });

  /// Unique identifier for this session
  final String id;

  /// Topic studied in this session
  final String topicId;

  /// When the session started
  final DateTime startTime;

  /// When the session ended
  final DateTime endTime;

  /// Number of cards reviewed in this session
  final int cardsReviewed;

  /// Number of correct answers
  final int correctAnswers;

  /// Average time per card in seconds
  final double averageResponseTime;

  /// Session duration in minutes
  int get durationMinutes => endTime.difference(startTime).inMinutes;

  /// Session accuracy (0-100)
  double get accuracy => cardsReviewed > 0 ? (correctAnswers / cardsReviewed) * 100 : 0;

  /// Cards per minute (study efficiency)
  double get cardsPerMinute => durationMinutes > 0 ? cardsReviewed / durationMinutes : 0;

  /// Create a new session
  factory LearningSession.create({
    required String topicId,
    required int cardsReviewed,
    required int correctAnswers,
    double averageResponseTime = 0,
  }) {
    final now = DateTime.now();
    return LearningSession(
      id: '${topicId}_${now.millisecondsSinceEpoch}',
      topicId: topicId,
      startTime: now.subtract(Duration(seconds: (averageResponseTime * cardsReviewed).toInt())),
      endTime: now,
      cardsReviewed: cardsReviewed,
      correctAnswers: correctAnswers,
      averageResponseTime: averageResponseTime,
    );
  }

  /// Create from JSON
  factory LearningSession.fromJson(Map<String, dynamic> json) {
    return LearningSession(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      cardsReviewed: json['cardsReviewed'] as int,
      correctAnswers: json['correctAnswers'] as int,
      averageResponseTime: (json['averageResponseTime'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'cardsReviewed': cardsReviewed,
      'correctAnswers': correctAnswers,
      'averageResponseTime': averageResponseTime,
    };
  }

  @override
  String toString() {
    return 'LearningSession(topic: $topicId, cards: $cardsReviewed, '
           'accuracy: ${accuracy.toStringAsFixed(1)}%, duration: ${durationMinutes}min)';
  }
}

/// Aggregate statistics for a time period
class PeriodStats {
  final int totalSessions;
  final int totalCards;
  final int totalCorrect;
  final int totalMinutes;
  final double averageAccuracy;
  final double averageSessionLength;

  PeriodStats({
    required this.totalSessions,
    required this.totalCards,
    required this.totalCorrect,
    required this.totalMinutes,
    required this.averageAccuracy,
    required this.averageSessionLength,
  });

  /// Calculate from a list of sessions
  factory PeriodStats.fromSessions(List<LearningSession> sessions) {
    if (sessions.isEmpty) {
      return PeriodStats(
        totalSessions: 0,
        totalCards: 0,
        totalCorrect: 0,
        totalMinutes: 0,
        averageAccuracy: 0,
        averageSessionLength: 0,
      );
    }

    final totalCards = sessions.fold<int>(0, (sum, s) => sum + s.cardsReviewed);
    final totalCorrect = sessions.fold<int>(0, (sum, s) => sum + s.correctAnswers);
    final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    final avgAccuracy = totalCards > 0 ? (totalCorrect / totalCards) * 100 : 0.0;
    final avgSessionLength = (totalMinutes / sessions.length).toDouble();

    return PeriodStats(
      totalSessions: sessions.length,
      totalCards: totalCards,
      totalCorrect: totalCorrect,
      totalMinutes: totalMinutes,
      averageAccuracy: avgAccuracy,
      averageSessionLength: avgSessionLength,
    );
  }
}
