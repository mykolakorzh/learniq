import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_review.dart';

/// Service for managing spaced repetition learning using the SM-2 algorithm
///
/// The SM-2 algorithm optimizes review intervals based on how well you remember each card:
/// - Easy cards: reviewed less frequently
/// - Hard cards: reviewed more frequently
/// - Adapts to your learning pace automatically
///
/// Quality ratings (0-5):
/// - 5: Perfect response
/// - 4: Correct response after hesitation
/// - 3: Correct response with difficulty
/// - 2: Incorrect but remembered
/// - 1: Incorrect, barely remembered
/// - 0: Complete blackout
class SpacedRepetitionService {
  /// Key prefix for storing card reviews
  static const String _reviewKeyPrefix = 'card_review_';

  /// Get the review data for a specific card
  static Future<CardReview?> getCardReview(String cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_reviewKeyPrefix$cardId');

    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CardReview.fromJson(json);
    } catch (e) {
      // Invalid data, return null
      return null;
    }
  }

  /// Save review data for a card
  static Future<void> _saveCardReview(CardReview review) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(review.toJson());
    await prefs.setString('$_reviewKeyPrefix${review.cardId}', jsonString);
  }

  /// Get all review data for a specific topic
  static Future<List<CardReview>> getTopicReviews(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final reviews = <CardReview>[];
    for (final key in keys) {
      if (key.startsWith(_reviewKeyPrefix)) {
        final jsonString = prefs.getString(key);
        if (jsonString != null) {
          try {
            final review = CardReview.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>,
            );
            if (review.topicId == topicId) {
              reviews.add(review);
            }
          } catch (e) {
            // Skip invalid reviews
            continue;
          }
        }
      }
    }

    return reviews;
  }

  /// Get cards that are due for review in a topic
  static Future<List<String>> getDueCardIds(String topicId) async {
    final reviews = await getTopicReviews(topicId);
    final now = DateTime.now();

    return reviews
        .where((review) => review.nextReviewDate.isBefore(now))
        .map((review) => review.cardId)
        .toList();
  }

  /// Get count of cards due for review in a topic
  static Future<int> getDueCardsCount(String topicId) async {
    final dueCards = await getDueCardIds(topicId);
    return dueCards.length;
  }

  /// Record a card review and calculate next review date using SM-2 algorithm
  ///
  /// [cardId] - The card being reviewed
  /// [topicId] - The topic this card belongs to
  /// [quality] - Quality of recall (0-5):
  ///   - 5: Perfect response
  ///   - 4: Correct response after hesitation
  ///   - 3: Correct response with difficulty
  ///   - 2: Incorrect but remembered
  ///   - 1: Incorrect, barely remembered
  ///   - 0: Complete blackout
  ///
  /// Returns the updated [CardReview] with new interval and next review date
  static Future<CardReview> recordReview({
    required String cardId,
    required String topicId,
    required int quality,
  }) async {
    // Validate quality (0-5)
    final clampedQuality = quality.clamp(0, 5);

    // Get existing review or create new one
    CardReview? review = await getCardReview(cardId);
    review ??= CardReview.newCard(cardId: cardId, topicId: topicId);

    // Calculate new values using SM-2 algorithm
    final result = _calculateSM2(
      easinessFactor: review.easinessFactor,
      repetitions: review.repetitions,
      intervalDays: review.intervalDays,
      quality: clampedQuality,
    );

    // Create updated review
    final updatedReview = review.copyWith(
      easinessFactor: result.easinessFactor,
      repetitions: result.repetitions,
      intervalDays: result.intervalDays,
      nextReviewDate: DateTime.now().add(Duration(days: result.intervalDays)),
      lastReviewDate: DateTime.now(),
      totalReviews: review.totalReviews + 1,
      correctReviews: review.correctReviews + (clampedQuality >= 3 ? 1 : 0),
    );

    // Save to storage
    await _saveCardReview(updatedReview);

    return updatedReview;
  }

  /// SM-2 Algorithm Implementation
  ///
  /// This is the core spaced repetition logic developed by Piotr Wozniak
  /// It calculates optimal review intervals based on recall quality
  static _SM2Result _calculateSM2({
    required double easinessFactor,
    required int repetitions,
    required int intervalDays,
    required int quality,
  }) {
    // Calculate new Easiness Factor (EF)
    // EF is adjusted based on quality of recall
    double newEF = easinessFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    // EF must be at least 1.3
    newEF = newEF.clamp(1.3, 2.5);

    int newRepetitions;
    int newInterval;

    if (quality < 3) {
      // Incorrect response - restart from beginning
      newRepetitions = 0;
      newInterval = 1; // Review tomorrow
    } else {
      // Correct response - increase interval
      newRepetitions = repetitions + 1;

      if (newRepetitions == 1) {
        newInterval = 1; // First review: 1 day
      } else if (newRepetitions == 2) {
        newInterval = 6; // Second review: 6 days
      } else {
        // Subsequent reviews: multiply previous interval by EF
        newInterval = (intervalDays * newEF).round();
      }
    }

    return _SM2Result(
      easinessFactor: newEF,
      repetitions: newRepetitions,
      intervalDays: newInterval,
    );
  }

  /// Get learning statistics for a topic
  static Future<TopicLearningStats> getTopicStats(String topicId) async {
    final reviews = await getTopicReviews(topicId);
    final now = DateTime.now();

    int totalCards = reviews.length;
    int dueCards = reviews.where((r) => r.nextReviewDate.isBefore(now)).length;
    int masteredCards = reviews.where((r) => r.repetitions >= 5 && r.easinessFactor > 2.0).length;
    int learningCards = reviews.where((r) => r.repetitions > 0 && r.repetitions < 5).length;
    int newCards = reviews.where((r) => r.totalReviews == 0).length;

    double avgAccuracy = 0;
    if (reviews.isNotEmpty) {
      avgAccuracy = reviews.map((r) => r.accuracy).reduce((a, b) => a + b) / reviews.length;
    }

    return TopicLearningStats(
      totalCards: totalCards,
      dueCards: dueCards,
      masteredCards: masteredCards,
      learningCards: learningCards,
      newCards: newCards,
      averageAccuracy: avgAccuracy,
    );
  }

  /// Clear all review data (for testing/debugging)
  static Future<void> clearAllReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith(_reviewKeyPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  /// Clear reviews for a specific topic
  static Future<void> clearTopicReviews(String topicId) async {
    final reviews = await getTopicReviews(topicId);
    final prefs = await SharedPreferences.getInstance();

    for (final review in reviews) {
      await prefs.remove('$_reviewKeyPrefix${review.cardId}');
    }
  }
}

/// Result of SM-2 calculation
class _SM2Result {
  final double easinessFactor;
  final int repetitions;
  final int intervalDays;

  _SM2Result({
    required this.easinessFactor,
    required this.repetitions,
    required this.intervalDays,
  });
}

/// Learning statistics for a topic
class TopicLearningStats {
  final int totalCards;
  final int dueCards;
  final int masteredCards;
  final int learningCards;
  final int newCards;
  final double averageAccuracy;

  TopicLearningStats({
    required this.totalCards,
    required this.dueCards,
    required this.masteredCards,
    required this.learningCards,
    required this.newCards,
    required this.averageAccuracy,
  });

  /// Percentage of cards that are mastered
  double get masteryPercentage =>
      totalCards > 0 ? (masteredCards / totalCards) * 100 : 0;
}
