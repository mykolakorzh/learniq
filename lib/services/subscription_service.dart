import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/app_config.dart';

/// Production-ready subscription service using RevenueCat
///
/// Features:
/// - Real App Store subscription handling
/// - 7-day free trial support
/// - Auto-renewing subscriptions
/// - Receipt validation
/// - Restore purchases
/// - Cross-device sync
///
/// Setup Required:
/// 1. Create RevenueCat account: https://app.revenuecat.com
/// 2. Add your app in RevenueCat dashboard
/// 3. Create subscription products in App Store Connect
/// 4. Configure products in RevenueCat (link to App Store)
/// 5. Replace API_KEY_IOS below with your RevenueCat API key
class SubscriptionService {
  // RevenueCat API key - loaded from AppConfig
  // Set via environment variable: --dart-define=REVENUECAT_API_KEY_IOS=your_key_here
  // Or update AppConfig.revenueCatApiKeyIOS directly
  static String get _apiKeyIOS => AppConfig.revenueCatApiKeyIOS;

  // RevenueCat entitlement identifier (configure in RevenueCat dashboard)
  static const String _entitlementID = 'premium';

  // Local cache keys
  static const String _keyLastCheckDate = 'subscription_last_check';
  static const String _keySubscriptionDate = 'subscription_activation_date';

  static SubscriptionService? _instance;
  static SharedPreferences? _prefs;
  static bool _isConfigured = false;

  SubscriptionService._();

  /// Get singleton instance
  static Future<SubscriptionService> getInstance() async {
    if (_instance == null) {
      _instance = SubscriptionService._();
      _prefs = await SharedPreferences.getInstance();
      await _instance!._configure();
    }
    return _instance!;
  }

  /// Configure RevenueCat SDK
  Future<void> _configure() async {
    if (_isConfigured) return;

    try {
      // Configure RevenueCat
      await Purchases.setLogLevel(
        kDebugMode ? LogLevel.debug : LogLevel.info,
      );

      final configuration = PurchasesConfiguration(_apiKeyIOS);
      await Purchases.configure(configuration);

      _isConfigured = true;

      // Update cached subscription status
      await _updateSubscriptionStatus();
    } catch (e) {
      // If API key not set or RevenueCat fails, continue in demo mode
      print('RevenueCat configuration failed: $e');
      print('Running in demo mode. Set API key to enable real subscriptions.');
    }
  }

  /// Check if user has an active premium subscription
  Future<bool> hasActiveSubscription() async {
    if (!_isConfigured) {
      // Demo mode: use local storage
      return _prefs?.getBool('has_premium_subscription') ?? false;
    }

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final hasEntitlement = customerInfo.entitlements.active.containsKey(_entitlementID);

      // Cache the result
      await _prefs?.setBool('has_premium_subscription', hasEntitlement);

      return hasEntitlement;
    } catch (e) {
      print('Error checking subscription: $e');
      // Fall back to cached value
      return _prefs?.getBool('has_premium_subscription') ?? false;
    }
  }

  /// Check if user is in trial period
  Future<bool> isInTrialPeriod() async {
    if (!_isConfigured) {
      // Demo mode: check trial dates
      final trialStartDate = _prefs?.getString('trial_start_date');
      if (trialStartDate == null) return false;

      final startDate = DateTime.parse(trialStartDate);
      final now = DateTime.now();
      final daysSinceStart = now.difference(startDate).inDays;

      return daysSinceStart < 7;
    }

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active[_entitlementID];

      if (entitlement == null) return false;

      // Check if in introductory period (trial)
      return entitlement.periodType == PeriodType.intro ||
             entitlement.periodType == PeriodType.trial;
    } catch (e) {
      print('Error checking trial status: $e');
      return false;
    }
  }

  /// Get available subscription packages
  Future<List<Package>> getAvailablePackages() async {
    if (!_isConfigured) {
      throw Exception('RevenueCat not configured. Please set API key.');
    }

    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        return [];
      }

      return offerings.current!.availablePackages;
    } catch (e) {
      print('Error fetching packages: $e');
      return [];
    }
  }

  /// Purchase a subscription package
  Future<bool> purchasePackage(Package package) async {
    if (!_isConfigured) {
      throw Exception('RevenueCat not configured. Please set API key.');
    }

    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      final hasEntitlement = purchaserInfo.entitlements.active.containsKey(_entitlementID);

      if (hasEntitlement) {
        await _prefs?.setString(
          _keySubscriptionDate,
          DateTime.now().toIso8601String(),
        );
      }

      return hasEntitlement;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        print('User cancelled purchase');
      } else if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        print('Product already purchased');
        return true;
      } else {
        print('Purchase error: ${e.message}');
      }
      return false;
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    if (!_isConfigured) {
      // Demo mode: check local storage
      return _prefs?.getBool('has_premium_subscription') ?? false;
    }

    try {
      final customerInfo = await Purchases.restorePurchases();
      final hasEntitlement = customerInfo.entitlements.active.containsKey(_entitlementID);

      // Cache the result
      await _prefs?.setBool('has_premium_subscription', hasEntitlement);

      return hasEntitlement;
    } catch (e) {
      print('Error restoring purchases: $e');
      return false;
    }
  }

  /// Get subscription activation date (if available)
  Future<DateTime?> getSubscriptionDate() async {
    final dateString = _prefs?.getString(_keySubscriptionDate);
    if (dateString != null) {
      return DateTime.tryParse(dateString);
    }

    if (!_isConfigured) return null;

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active[_entitlementID];

      if (entitlement != null) {
        final purchaseDate = entitlement.latestPurchaseDate;
        // Cache it
        await _prefs?.setString(_keySubscriptionDate, purchaseDate);
        return DateTime.parse(purchaseDate);
      }
    } catch (e) {
      print('Error getting subscription date: $e');
    }

    return null;
  }

  /// Check if topic is accessible (free topic OR has subscription OR in trial)
  Future<bool> isTopicAccessible(bool isTopicFree) async {
    if (isTopicFree) {
      return true; // Free topics are always accessible
    }

    // Check if user has active subscription
    final hasSubscription = await hasActiveSubscription();
    if (hasSubscription) return true;

    // Check if user is in trial period
    final inTrial = await isInTrialPeriod();
    return inTrial;
  }

  /// Update cached subscription status
  Future<void> _updateSubscriptionStatus() async {
    if (!_isConfigured) return;

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final hasEntitlement = customerInfo.entitlements.active.containsKey(_entitlementID);

      await _prefs?.setBool('has_premium_subscription', hasEntitlement);
      await _prefs?.setString(
        _keyLastCheckDate,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('Error updating subscription status: $e');
    }
  }

  /// Listen for subscription updates (call in main app initialization)
  void listenForSubscriptionUpdates(Function(bool) onSubscriptionChanged) {
    if (!_isConfigured) return;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      final hasEntitlement = customerInfo.entitlements.active.containsKey(_entitlementID);
      await _prefs?.setBool('has_premium_subscription', hasEntitlement);
      onSubscriptionChanged(hasEntitlement);
    });
  }

  // ========== Demo Mode Functions (for testing without RevenueCat setup) ==========

  /// Start trial (demo mode only)
  Future<void> startTrial() async {
    await _prefs?.setString('trial_start_date', DateTime.now().toIso8601String());
    await _prefs?.setBool('has_premium_subscription', true);
  }

  /// Activate subscription (demo mode only)
  Future<void> activateSubscription() async {
    await _prefs?.setBool('has_premium_subscription', true);
    await _prefs?.setString(
      _keySubscriptionDate,
      DateTime.now().toIso8601String(),
    );
  }

  /// Deactivate subscription (demo mode only)
  Future<void> deactivateSubscription() async {
    await _prefs?.setBool('has_premium_subscription', false);
    await _prefs?.remove(_keySubscriptionDate);
    await _prefs?.remove('trial_start_date');
  }

  /// Get customer info for debugging
  Future<String> getDebugInfo() async {
    if (!_isConfigured) {
      return 'RevenueCat not configured (demo mode)';
    }

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return '''
User ID: ${customerInfo.originalAppUserId}
Has Entitlement: ${customerInfo.entitlements.active.containsKey(_entitlementID)}
Active Subscriptions: ${customerInfo.activeSubscriptions.join(', ')}
Entitlements: ${customerInfo.entitlements.all.keys.join(', ')}
''';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
