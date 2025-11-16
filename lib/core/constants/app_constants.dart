import '../config/app_config.dart';

/// App-wide constants
/// 
/// @deprecated Use AppConfig instead
/// This class is kept for backward compatibility
@Deprecated('Use AppConfig instead')
class AppConstants {
  // Legal document URLs
  static String get privacyPolicyUrl => AppConfig.privacyPolicyUrl;
  static String get termsOfServiceUrl => AppConfig.termsOfServiceUrl;
  
  // Support email
  static String get supportEmail => AppConfig.supportEmail;
  
  // App Store URLs
  static String get appStoreSubscriptionManagement => AppConfig.appStoreSubscriptionManagement;
  
  // Private constructor to prevent instantiation
  AppConstants._();
}

