/// Model for tracking individual card review history using SM-2 spaced repetition algorithm
///
/// The SM-2 algorithm uses:
/// - Easiness Factor (EF): Measures how easy the card is (starts at 2.5)
/// - Repetitions: Number of consecutive correct reviews
/// - Interval: Days until next review
/// - Next Review Date: When the card should be reviewed again
class CardReview {
  CardReview({
    required this.cardId,
    required this.topicId,
    required this.easinessFactor,
    required this.repetitions,
    required this.intervalDays,
    required this.nextReviewDate,
    required this.lastReviewDate,
    this.totalReviews = 0,
    this.correctReviews = 0,
  });

  /// Unique identifier for the card being reviewed
  final String cardId;

  /// Topic this card belongs to
  final String topicId;

  /// Easiness Factor (EF) - determines how quickly intervals grow
  /// Range: 1.3 - 2.5 (default 2.5)
  /// Higher = easier card = longer intervals
  final double easinessFactor;

  /// Number of consecutive correct reviews
  /// Resets to 0 on incorrect review
  final int repetitions;

  /// Current interval in days until next review
  final int intervalDays;

  /// When this card should be reviewed next
  final DateTime nextReviewDate;

  /// When this card was last reviewed
  final DateTime lastReviewDate;

  /// Total number of times this card has been reviewed
  final int totalReviews;

  /// Number of correct reviews (for accuracy calculation)
  final int correctReviews;

  /// Check if this card is due for review
  bool get isDue => DateTime.now().isAfter(nextReviewDate);

  /// Calculate accuracy percentage (0-100)
  double get accuracy => totalReviews > 0 ? (correctReviews / totalReviews) * 100 : 0;

  /// Create a new review for a card that's never been reviewed
  factory CardReview.newCard({
    required String cardId,
    required String topicId,
  }) {
    return CardReview(
      cardId: cardId,
      topicId: topicId,
      easinessFactor: 2.5, // Default starting EF
      repetitions: 0,
      intervalDays: 0,
      nextReviewDate: DateTime.now(), // Due immediately
      lastReviewDate: DateTime.now(),
      totalReviews: 0,
      correctReviews: 0,
    );
  }

  /// Create CardReview from JSON (for storage/retrieval)
  factory CardReview.fromJson(Map<String, dynamic> json) {
    return CardReview(
      cardId: json['cardId'] as String,
      topicId: json['topicId'] as String,
      easinessFactor: (json['easinessFactor'] as num).toDouble(),
      repetitions: json['repetitions'] as int,
      intervalDays: json['intervalDays'] as int,
      nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
      lastReviewDate: DateTime.parse(json['lastReviewDate'] as String),
      totalReviews: json['totalReviews'] as int? ?? 0,
      correctReviews: json['correctReviews'] as int? ?? 0,
    );
  }

  /// Convert CardReview to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'topicId': topicId,
      'easinessFactor': easinessFactor,
      'repetitions': repetitions,
      'intervalDays': intervalDays,
      'nextReviewDate': nextReviewDate.toIso8601String(),
      'lastReviewDate': lastReviewDate.toIso8601String(),
      'totalReviews': totalReviews,
      'correctReviews': correctReviews,
    };
  }

  /// Create a copy with updated fields
  CardReview copyWith({
    String? cardId,
    String? topicId,
    double? easinessFactor,
    int? repetitions,
    int? intervalDays,
    DateTime? nextReviewDate,
    DateTime? lastReviewDate,
    int? totalReviews,
    int? correctReviews,
  }) {
    return CardReview(
      cardId: cardId ?? this.cardId,
      topicId: topicId ?? this.topicId,
      easinessFactor: easinessFactor ?? this.easinessFactor,
      repetitions: repetitions ?? this.repetitions,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      totalReviews: totalReviews ?? this.totalReviews,
      correctReviews: correctReviews ?? this.correctReviews,
    );
  }

  @override
  String toString() {
    return 'CardReview(cardId: $cardId, EF: $easinessFactor, reps: $repetitions, '
           'interval: $intervalDays days, next: ${nextReviewDate.toLocal()}, '
           'accuracy: ${accuracy.toStringAsFixed(1)}%)';
  }
}
