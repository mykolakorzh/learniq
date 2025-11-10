/// Model for tracking daily learning streaks and goals
///
/// Tracks user engagement through:
/// - Daily streak count (consecutive days of activity)
/// - Daily goal (target number of cards to review)
/// - Progress towards today's goal
/// - Historical best streak
class DailyStreak {
  DailyStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.dailyGoal,
    required this.cardsReviewedToday,
    required this.totalReviews,
  });

  /// Current streak in days (consecutive days with activity)
  final int currentStreak;

  /// Longest streak ever achieved (motivational)
  final int longestStreak;

  /// Last date when user reviewed cards (yyyy-MM-dd format)
  final DateTime lastActivityDate;

  /// Daily goal - number of cards to review each day
  final int dailyGoal;

  /// Cards reviewed today (resets at midnight)
  final int cardsReviewedToday;

  /// Total number of reviews across all time
  final int totalReviews;

  /// Check if user has met today's goal
  bool get goalMet => cardsReviewedToday >= dailyGoal;

  /// Progress towards today's goal (0.0 to 1.0+)
  double get goalProgress => dailyGoal > 0 ? (cardsReviewedToday / dailyGoal).clamp(0.0, 1.0) : 0.0;

  /// Check if user has activity today
  bool get hasActivityToday {
    final today = _dateOnly(DateTime.now());
    final lastActivity = _dateOnly(lastActivityDate);
    return today.isAtSameMomentAs(lastActivity);
  }

  /// Check if user missed yesterday (streak break)
  bool get missedYesterday {
    final yesterday = _dateOnly(DateTime.now().subtract(const Duration(days: 1)));
    final lastActivity = _dateOnly(lastActivityDate);
    return lastActivity.isBefore(yesterday);
  }

  /// Create a new streak record (first time user)
  factory DailyStreak.initial({int dailyGoal = 20}) {
    return DailyStreak(
      currentStreak: 0,
      longestStreak: 0,
      lastActivityDate: DateTime.now(),
      dailyGoal: dailyGoal,
      cardsReviewedToday: 0,
      totalReviews: 0,
    );
  }

  /// Create DailyStreak from JSON (for storage/retrieval)
  factory DailyStreak.fromJson(Map<String, dynamic> json) {
    return DailyStreak(
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastActivityDate: json['lastActivityDate'] != null
          ? DateTime.parse(json['lastActivityDate'] as String)
          : DateTime.now(),
      dailyGoal: json['dailyGoal'] as int? ?? 20,
      cardsReviewedToday: json['cardsReviewedToday'] as int? ?? 0,
      totalReviews: json['totalReviews'] as int? ?? 0,
    );
  }

  /// Convert DailyStreak to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate.toIso8601String(),
      'dailyGoal': dailyGoal,
      'cardsReviewedToday': cardsReviewedToday,
      'totalReviews': totalReviews,
    };
  }

  /// Create a copy with updated fields
  DailyStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    int? dailyGoal,
    int? cardsReviewedToday,
    int? totalReviews,
  }) {
    return DailyStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      cardsReviewedToday: cardsReviewedToday ?? this.cardsReviewedToday,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  /// Helper to get date-only (strip time)
  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  String toString() {
    return 'DailyStreak(current: $currentStreak days, longest: $longestStreak days, '
           'today: $cardsReviewedToday/$dailyGoal, total: $totalReviews)';
  }
}
