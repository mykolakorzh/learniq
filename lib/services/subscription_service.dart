import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing subscription state
///
/// This is a simplified local-storage subscription service for MVP.
/// For production, integrate with actual IAP (in_app_purchase package).
class SubscriptionService {
  static const String _keyHasSubscription = 'has_premium_subscription';
  static const String _keySubscriptionDate = 'subscription_activation_date';

  static SubscriptionService? _instance;
  static SharedPreferences? _prefs;

  SubscriptionService._();

  /// Get singleton instance
  static Future<SubscriptionService> getInstance() async {
    if (_instance == null) {
      _instance = SubscriptionService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// Check if user has an active subscription
  Future<bool> hasActiveSubscription() async {
    return _prefs?.getBool(_keyHasSubscription) ?? false;
  }

  /// Activate premium subscription (for testing)
  /// In production, this would be called after successful IAP
  Future<void> activateSubscription() async {
    await _prefs?.setBool(_keyHasSubscription, true);
    await _prefs?.setString(
      _keySubscriptionDate,
      DateTime.now().toIso8601String(),
    );
  }

  /// Deactivate subscription (for testing)
  /// In production, this would happen when subscription expires
  Future<void> deactivateSubscription() async {
    await _prefs?.setBool(_keyHasSubscription, false);
    await _prefs?.remove(_keySubscriptionDate);
  }

  /// Restore purchases (simulated for MVP)
  /// In production, this would verify with App Store/Play Store
  Future<bool> restorePurchases() async {
    // For MVP, just check if we have a stored subscription
    final hasSubscription = await hasActiveSubscription();
    return hasSubscription;
  }

  /// Get subscription activation date (if available)
  Future<DateTime?> getSubscriptionDate() async {
    final dateString = _prefs?.getString(_keySubscriptionDate);
    if (dateString != null) {
      return DateTime.tryParse(dateString);
    }
    return null;
  }

  /// Check if topic is accessible (free topic OR has subscription)
  Future<bool> isTopicAccessible(bool isTopicFree) async {
    if (isTopicFree) {
      return true; // Free topics are always accessible
    }
    return await hasActiveSubscription();
  }
}
