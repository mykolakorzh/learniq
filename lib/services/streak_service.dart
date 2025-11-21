import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_streak.dart';

/// Service for managing daily streaks, goals, and user engagement tracking
///
/// Key Features:
/// - Tracks consecutive days of learning (streaks)
/// - Daily goal setting and progress tracking
/// - Automatic streak updates and resets
/// - Motivational statistics (longest streak, total reviews)
class StreakService {
  /// Key for storing streak data
  static const String _streakKey = 'daily_streak';

  /// Get current streak data
  static Future<DailyStreak> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_streakKey);

    if (jsonString == null) {
      // First time user - create initial streak
      final initialStreak = DailyStreak.initial();
      await _saveStreak(initialStreak);
      return initialStreak;
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      var streak = DailyStreak.fromJson(json);

      // Check if we need to reset daily counter (new day)
      streak = _checkAndResetDaily(streak);

      return streak;
    } catch (e) {
      // Invalid data, return initial
      final initialStreak = DailyStreak.initial();
      await _saveStreak(initialStreak);
      return initialStreak;
    }
  }

  /// Save streak data
  static Future<void> _saveStreak(DailyStreak streak) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(streak.toJson());
    await prefs.setString(_streakKey, jsonString);
  }

  /// Record a card review and update streak
  ///
  /// This should be called every time a user reviews a card.
  /// It will:
  /// - Increment cards reviewed today
  /// - Increment total reviews
  /// - Update streak if it's the first review of the day
  static Future<DailyStreak> recordReview() async {
    var streak = await getStreak();

    // Check if this is first review of the day BEFORE updating the date
    final isFirstReviewToday = !streak.hasActivityToday;
    
    // Store the OLD lastActivityDate for streak calculation
    final oldLastActivityDate = streak.lastActivityDate;

    // Update counters
    streak = streak.copyWith(
      cardsReviewedToday: streak.cardsReviewedToday + 1,
      totalReviews: streak.totalReviews + 1,
      lastActivityDate: DateTime.now(),
    );

    // Update streak if first review of the day
    // Pass the OLD date for comparison
    if (isFirstReviewToday) {
      streak = _updateStreakCount(streak, oldLastActivityDate);
    }

    await _saveStreak(streak);
    return streak;
  }

  /// Update streak count based on last activity date
  /// 
  /// [previousLastActivity] is the last activity date BEFORE the current update
  /// This allows us to compare yesterday's activity correctly
  static DailyStreak _updateStreakCount(DailyStreak streak, DateTime previousLastActivity) {
    final today = _dateOnly(DateTime.now());
    final lastActivity = _dateOnly(previousLastActivity);
    final yesterday = today.subtract(const Duration(days: 1));

    int newStreak;

    if (lastActivity.isAtSameMomentAs(yesterday)) {
      // Consecutive day - increment streak
      newStreak = streak.currentStreak + 1;
    } else if (lastActivity.isAtSameMomentAs(today)) {
      // Same day - keep current streak (shouldn't happen if called correctly, but safe)
      newStreak = streak.currentStreak;
    } else if (lastActivity.isBefore(yesterday)) {
      // Missed day(s) - reset streak to 1 (starting fresh today)
      newStreak = 1;
    } else {
      // Future date (shouldn't happen) - keep current
      newStreak = streak.currentStreak;
    }
    
    // Ensure streak starts at 1 if it was 0 (first time user)
    if (newStreak == 0 && lastActivity.isBefore(today)) {
      newStreak = 1;
    }

    // Update longest streak if needed
    final newLongest = newStreak > streak.longestStreak ? newStreak : streak.longestStreak;

    return streak.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
    );
  }

  /// Check if we need to reset daily counter (new day)
  static DailyStreak _checkAndResetDaily(DailyStreak streak) {
    final today = _dateOnly(DateTime.now());
    final lastActivity = _dateOnly(streak.lastActivityDate);

    if (!today.isAtSameMomentAs(lastActivity)) {
      // New day - reset daily counter
      // But don't update streak yet (only when they actually review something)
      return streak.copyWith(cardsReviewedToday: 0);
    }

    return streak;
  }

  /// Update daily goal
  static Future<DailyStreak> setDailyGoal(int goal) async {
    var streak = await getStreak();
    streak = streak.copyWith(dailyGoal: goal);
    await _saveStreak(streak);
    return streak;
  }

  /// Get streak status for display
  static Future<StreakStatus> getStreakStatus() async {
    final streak = await getStreak();
    return StreakStatus(
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      cardsReviewedToday: streak.cardsReviewedToday,
      dailyGoal: streak.dailyGoal,
      goalMet: streak.goalMet,
      goalProgress: streak.goalProgress,
      totalReviews: streak.totalReviews,
    );
  }

  /// Reset streak (for testing or user request)
  static Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_streakKey);
  }

  /// Helper to get date-only (strip time)
  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

/// Simplified streak status for UI display
class StreakStatus {
  final int currentStreak;
  final int longestStreak;
  final int cardsReviewedToday;
  final int dailyGoal;
  final bool goalMet;
  final double goalProgress;
  final int totalReviews;

  StreakStatus({
    required this.currentStreak,
    required this.longestStreak,
    required this.cardsReviewedToday,
    required this.dailyGoal,
    required this.goalMet,
    required this.goalProgress,
    required this.totalReviews,
  });

  /// Get motivational message based on progress
  String get motivationalMessage {
    if (goalMet) {
      return "Goal achieved! 🎉";
    } else if (goalProgress >= 0.75) {
      return "Almost there! 💪";
    } else if (goalProgress >= 0.5) {
      return "Halfway done! 🔥";
    } else if (goalProgress >= 0.25) {
      return "Good start! 👍";
    } else if (cardsReviewedToday > 0) {
      return "Keep going! ⚡";
    } else {
      return "Ready to learn? 📚";
    }
  }

  /// Get streak message
  String get streakMessage {
    if (currentStreak == 0) {
      return "Start your streak!";
    } else if (currentStreak == 1) {
      return "1 day streak!";
    } else if (currentStreak < 7) {
      return "$currentStreak days streak!";
    } else if (currentStreak < 30) {
      return "$currentStreak days streak! 🔥";
    } else {
      return "$currentStreak days streak! 🔥🔥";
    }
  }
}
