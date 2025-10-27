import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Learniq'**
  String get appTitle;

  /// Title for the topics screen
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topicsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get settingsAppPreferences;

  /// No description provided for @settingsSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get settingsSoundEffects;

  /// No description provided for @settingsSoundEffectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play sounds for interactions'**
  String get settingsSoundEffectsSubtitle;

  /// No description provided for @settingsHapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get settingsHapticFeedback;

  /// No description provided for @settingsHapticFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on interactions'**
  String get settingsHapticFeedbackSubtitle;

  /// No description provided for @settingsTts.
  ///
  /// In en, this message translates to:
  /// **'Text-to-Speech'**
  String get settingsTts;

  /// No description provided for @settingsTtsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable pronunciation audio'**
  String get settingsTtsSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get settingsLanguageRussian;

  /// No description provided for @settingsLanguageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get settingsLanguageUkrainian;

  /// No description provided for @settingsLanguageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get settingsLanguageChanged;

  /// No description provided for @settingsLanguageChangedRu.
  ///
  /// In en, this message translates to:
  /// **'Язык изменен'**
  String get settingsLanguageChangedRu;

  /// No description provided for @settingsLanguageChangedUk.
  ///
  /// In en, this message translates to:
  /// **'Мову змінено'**
  String get settingsLanguageChangedUk;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsClearProgress.
  ///
  /// In en, this message translates to:
  /// **'Clear Progress'**
  String get settingsClearProgress;

  /// No description provided for @settingsClearProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all learning progress'**
  String get settingsClearProgressSubtitle;

  /// No description provided for @settingsResetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get settingsResetToDefaults;

  /// No description provided for @settingsResetToDefaultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore default settings'**
  String get settingsResetToDefaultsSubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsDeveloper;

  /// No description provided for @settingsDeveloperName.
  ///
  /// In en, this message translates to:
  /// **'Mykola Korzh'**
  String get settingsDeveloperName;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View our privacy policy'**
  String get settingsPrivacyPolicySubtitle;

  /// No description provided for @settingsPrivacyPolicyMessage.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy will open here'**
  String get settingsPrivacyPolicyMessage;

  /// No description provided for @settingsLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get settingsLicense;

  /// No description provided for @settingsLicenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Proprietary - All rights reserved'**
  String get settingsLicenseSubtitle;

  /// No description provided for @settingsClearProgressDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Progress?'**
  String get settingsClearProgressDialogTitle;

  /// No description provided for @settingsClearProgressDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your learning progress and statistics. This action cannot be undone.'**
  String get settingsClearProgressDialogMessage;

  /// No description provided for @settingsClearProgressDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsClearProgressDialogConfirm;

  /// No description provided for @settingsClearProgressDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsClearProgressDialogCancel;

  /// No description provided for @settingsClearProgressSuccess.
  ///
  /// In en, this message translates to:
  /// **'Progress cleared'**
  String get settingsClearProgressSuccess;

  /// No description provided for @settingsResetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings?'**
  String get settingsResetDialogTitle;

  /// No description provided for @settingsResetDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This will restore all settings to their default values.'**
  String get settingsResetDialogMessage;

  /// No description provided for @settingsResetDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settingsResetDialogConfirm;

  /// No description provided for @settingsResetDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsResetDialogCancel;

  /// No description provided for @settingsResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings reset to defaults'**
  String get settingsResetSuccess;

  /// No description provided for @topicsFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load topics'**
  String get topicsFailedToLoad;

  /// No description provided for @topicsCards.
  ///
  /// In en, this message translates to:
  /// **'cards'**
  String get topicsCards;

  /// No description provided for @topicsCardCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String topicsCardCount(int count);

  /// No description provided for @topicsProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get topicsProgress;

  /// No description provided for @topicsMistakes.
  ///
  /// In en, this message translates to:
  /// **'Mistakes'**
  String get topicsMistakes;

  /// No description provided for @topicsFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get topicsFree;

  /// No description provided for @topicsFixMistakes.
  ///
  /// In en, this message translates to:
  /// **'Fix mistakes'**
  String get topicsFixMistakes;

  /// No description provided for @topicsChooseLearningMode.
  ///
  /// In en, this message translates to:
  /// **'Choose Learning Mode'**
  String get topicsChooseLearningMode;

  /// No description provided for @topicsYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get topicsYourProgress;

  /// No description provided for @topicsPracticeMistakes.
  ///
  /// In en, this message translates to:
  /// **'Practice Mistakes'**
  String get topicsPracticeMistakes;

  /// No description provided for @topicsPracticeMistakesFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus on your weak words ({count})'**
  String topicsPracticeMistakesFocus(int count);

  /// No description provided for @topicsLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get topicsLearn;

  /// No description provided for @topicsLearnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Study vocabulary cards'**
  String get topicsLearnSubtitle;

  /// No description provided for @topicsTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get topicsTest;

  /// No description provided for @topicsTestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practice with quiz'**
  String get topicsTestSubtitle;

  /// Title for the paywall screen
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get paywallTitle;

  /// Coming soon message for paywall
  ///
  /// In en, this message translates to:
  /// **'Subscription System'**
  String get paywallComingSoon;

  /// Description for paywall features
  ///
  /// In en, this message translates to:
  /// **'Premium features will be available soon. Here you\'ll be able to unlock additional topics and features.'**
  String get paywallDescription;

  /// Button to unlock premium features
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get paywallUnlockPremium;

  /// Button to restore previous purchases
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get paywallRestorePurchases;

  /// Button to go back to topics
  ///
  /// In en, this message translates to:
  /// **'Back to Topics'**
  String get paywallBackToTopics;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
