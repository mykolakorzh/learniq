import 'package:firebase_analytics/firebase_analytics.dart';

/// Service for tracking analytics events
/// 
/// Wraps Firebase Analytics to provide a clean interface for tracking
/// user behavior and app events throughout the app.
class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static FirebaseAnalyticsObserver? _observer;

  /// Initialize analytics service
  /// Should be called after Firebase.initializeApp()
  static Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
    } catch (e) {
      // Analytics not available - app can continue without it
      _analytics = null;
      _observer = null;
    }
  }

  /// Get the analytics instance
  static FirebaseAnalytics? get analytics => _analytics;

  /// Get the observer for navigation tracking
  static FirebaseAnalyticsObserver? get observer => _observer;

  /// Track a screen view
  static Future<void> logScreenView(String screenName) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logScreenView(screenName: screenName);
    } catch (e) {
      // Silently fail - analytics is not critical
    }
  }

  /// Track a learning session start
  static Future<void> logLearningSessionStart(String topicId) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'learning_session_start',
        parameters: {'topic_id': topicId},
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track a learning session complete
  static Future<void> logLearningSessionComplete({
    required String topicId,
    required int cardsReviewed,
    required double accuracy,
  }) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'learning_session_complete',
        parameters: {
          'topic_id': topicId,
          'cards_reviewed': cardsReviewed,
          'accuracy': accuracy,
        },
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track a test session start
  static Future<void> logTestSessionStart(String topicId) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'test_session_start',
        parameters: {'topic_id': topicId},
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track a test session complete
  static Future<void> logTestSessionComplete({
    required String topicId,
    required int totalCards,
    required int correctAnswers,
    required double accuracy,
  }) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'test_session_complete',
        parameters: {
          'topic_id': topicId,
          'total_cards': totalCards,
          'correct_answers': correctAnswers,
          'accuracy': accuracy,
        },
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track subscription purchase attempt
  static Future<void> logPurchaseAttempt(String packageId) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'purchase_attempt',
        parameters: {'package_id': packageId},
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track subscription purchase success
  static Future<void> logPurchaseSuccess({
    required String packageId,
    required String price,
    required String currency,
  }) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logPurchase(
        currency: currency,
        value: double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0,
        parameters: {'package_id': packageId},
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track subscription purchase cancellation
  static Future<void> logPurchaseCancelled(String packageId) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'purchase_cancelled',
        parameters: {'package_id': packageId},
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track paywall view
  static Future<void> logPaywallView() async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(name: 'paywall_view');
    } catch (e) {
      // Silently fail
    }
  }

  /// Track topic access attempt
  static Future<void> logTopicAccessAttempt(String topicId, bool isFree) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'topic_access_attempt',
        parameters: {
          'topic_id': topicId,
          'is_free': isFree,
        },
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Track card review
  static Future<void> logCardReview({
    required String cardId,
    required String topicId,
    required int quality,
  }) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'card_review',
        parameters: {
          'card_id': cardId,
          'topic_id': topicId,
          'quality': quality,
        },
      );
    } catch (e) {
      // Silently fail
    }
  }

  /// Set user property
  static Future<void> setUserProperty(String name, String? value) async {
    if (_analytics == null) return;
    try {
      await _analytics!.setUserProperty(name: name, value: value);
    } catch (e) {
      // Silently fail
    }
  }

  /// Set user ID (for cross-platform tracking)
  static Future<void> setUserId(String? userId) async {
    if (_analytics == null) return;
    try {
      await _analytics!.setUserId(id: userId);
    } catch (e) {
      // Silently fail
    }
  }
}

