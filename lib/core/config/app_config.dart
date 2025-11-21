import 'revenuecat_key.dart' as rc_key;

/// App configuration
/// 
/// For production, set these values via environment variables or
/// create a separate config file that's not committed to git.
class AppConfig {
  // RevenueCat API Key
  // Loaded from revenuecat_key.dart (not committed to git)
  // Can be overridden with environment variable: --dart-define=REVENUECAT_API_KEY_IOS=your_key
  static const String revenueCatApiKeyIOS = 
      String.fromEnvironment('REVENUECAT_API_KEY_IOS', defaultValue: rc_key.revenueCatApiKeyIOS);
  
  // Privacy Policy and Terms URLs
  // Update these when you host the documents
  static const String privacyPolicyUrl = 'https://mykolakorzh.github.io/learniq/privacy-policy';
  static const String termsOfServiceUrl = 'https://mykolakorzh.github.io/learniq/terms-of-service';
  
  // Support email
  static const String supportEmail = 'support@learniq.app';
  
  // App Store URLs
  static const String appStoreSubscriptionManagement = 'https://apps.apple.com/account/subscriptions';
  
  // Private constructor to prevent instantiation
  AppConfig._();
}

