// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Learniq';

  @override
  String get topicsTitle => 'Topics';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppPreferences => 'App Preferences';

  @override
  String get settingsSoundEffects => 'Sound Effects';

  @override
  String get settingsSoundEffectsSubtitle => 'Play sounds for interactions';

  @override
  String get settingsHapticFeedback => 'Haptic Feedback';

  @override
  String get settingsHapticFeedbackSubtitle => 'Vibrate on interactions';

  @override
  String get settingsTts => 'Text-to-Speech';

  @override
  String get settingsTtsSubtitle => 'Enable pronunciation audio';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageUkrainian => 'Українська';

  @override
  String get settingsLanguageChanged => 'Language changed';

  @override
  String get settingsLanguageChangedRu => 'Язык изменен';

  @override
  String get settingsLanguageChangedUk => 'Мову змінено';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsClearProgress => 'Clear Progress';

  @override
  String get settingsClearProgressSubtitle => 'Reset all learning progress';

  @override
  String get settingsResetToDefaults => 'Reset to Defaults';

  @override
  String get settingsResetToDefaultsSubtitle => 'Restore default settings';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDeveloper => 'Developer';

  @override
  String get settingsDeveloperName => 'Mykola Korzh';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'View our privacy policy';

  @override
  String get settingsPrivacyPolicyMessage => 'Privacy policy will open here';

  @override
  String get settingsLicense => 'License';

  @override
  String get settingsLicenseSubtitle => 'Proprietary - All rights reserved';

  @override
  String get settingsClearProgressDialogTitle => 'Clear All Progress?';

  @override
  String get settingsClearProgressDialogMessage =>
      'This will delete all your learning progress and statistics. This action cannot be undone.';

  @override
  String get settingsClearProgressDialogConfirm => 'Clear';

  @override
  String get settingsClearProgressDialogCancel => 'Cancel';

  @override
  String get settingsClearProgressSuccess => 'Progress cleared';

  @override
  String get settingsResetDialogTitle => 'Reset Settings?';

  @override
  String get settingsResetDialogMessage =>
      'This will restore all settings to their default values.';

  @override
  String get settingsResetDialogConfirm => 'Reset';

  @override
  String get settingsResetDialogCancel => 'Cancel';

  @override
  String get settingsResetSuccess => 'Settings reset to defaults';

  @override
  String get topicsFailedToLoad => 'Failed to load topics';

  @override
  String get topicsCards => 'cards';

  @override
  String topicsCardCount(int count) {
    return '$count cards';
  }

  @override
  String get topicsProgress => 'Progress';

  @override
  String get topicsMistakes => 'Mistakes';

  @override
  String get topicsFree => 'Free';

  @override
  String get topicsFixMistakes => 'Fix mistakes';

  @override
  String get topicsChooseLearningMode => 'Choose Learning Mode';

  @override
  String get topicsYourProgress => 'Your progress';

  @override
  String get topicsPracticeMistakes => 'Practice Mistakes';

  @override
  String topicsPracticeMistakesFocus(int count) {
    return 'Focus on your weak words ($count)';
  }

  @override
  String get topicsLearn => 'Learn';

  @override
  String get topicsLearnSubtitle => 'Study vocabulary cards';

  @override
  String get topicsTest => 'Test';

  @override
  String get topicsTestSubtitle => 'Practice with quiz';

  @override
  String get paywallTitle => 'Premium';

  @override
  String get paywallComingSoon => 'Subscription System';

  @override
  String get paywallDescription =>
      'Premium features will be available soon. Here you\'ll be able to unlock additional topics and features.';

  @override
  String get paywallUnlockPremium => 'Unlock Premium';

  @override
  String get paywallRestorePurchases => 'Restore Purchases';

  @override
  String get paywallBackToTopics => 'Back to Topics';
}
