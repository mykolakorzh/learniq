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
  String get statisticsTitle => 'Statistics';

  @override
  String get learnModeTitle => 'Learn Mode';

  @override
  String get testModeTitle => 'Test Mode';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingPage1Title => 'Master German Articles';

  @override
  String get onboardingPage1Description =>
      'Learn der, die, and das through beautiful visual flashcards with images that help you remember.';

  @override
  String get onboardingPage2Title => 'Interactive Quizzes';

  @override
  String get onboardingPage2Description =>
      'Test your knowledge with fun drag-and-drop quizzes. Get instant feedback and track your mistakes.';

  @override
  String get onboardingPage3Title => 'Perfect Pronunciation';

  @override
  String get onboardingPage3Description =>
      'Hear native German pronunciation with text-to-speech. Practice listening and speaking.';

  @override
  String get onboardingPage4Title => 'Track Your Progress';

  @override
  String get onboardingPage4Description =>
      'Monitor your learning journey with detailed statistics and achievement badges.';

  @override
  String get splashAppName => 'LearnIQ';

  @override
  String get splashTagline => 'Master German Articles';

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
  String settingsClearProgressError(String error) {
    return 'Failed to clear progress: $error';
  }

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
  String get topicsRetry => 'Retry';

  @override
  String topicsError(String error) {
    return 'Error: $error';
  }

  @override
  String get topicsPremium => 'Premium';

  @override
  String get topicsAll => 'All';

  @override
  String get topicsSearchHint => 'Search topics...';

  @override
  String get topicsSubtitle => 'Start your learning journey';

  @override
  String get topicsNoTopicsFound => 'No matching topics';

  @override
  String get topicsAdjustFilters => 'Try a different search term';

  @override
  String get topicsClearFilters => 'Clear Filters';

  @override
  String get topicsPreview => 'Preview';

  @override
  String get learnLoading => 'Loading learning cards...';

  @override
  String get learnErrorTitle => 'Unable to Load Cards';

  @override
  String get learnErrorMessage =>
      'There was a problem loading the learning cards. Please try again.';

  @override
  String get learnNoCardsTitle => 'No Cards Available';

  @override
  String get learnNoCardsMessage =>
      'This topic doesn\'t have any learning cards yet.';

  @override
  String get learnCongratulations => 'Congratulations!';

  @override
  String learnCompletedCards(int count) {
    return 'You\'ve completed all $count cards!';
  }

  @override
  String learnCardProgress(int current, int total) {
    return '$current of $total cards';
  }

  @override
  String get learnSwipeHint => 'Swipe left or right to navigate';

  @override
  String get learnTapToReveal => 'Tap to reveal translation';

  @override
  String get learnTapToFlipBack => 'Tap to flip back';

  @override
  String get learnHearPronunciation => 'Hear pronunciation';

  @override
  String get testLoading => 'Loading test cards...';

  @override
  String get testNoCardsTitle => 'No Cards Available';

  @override
  String get testNoCardsMessage => 'No cards available for this topic.';

  @override
  String get testReviewComplete => 'Review Complete!';

  @override
  String get testTestComplete => 'Test Complete!';

  @override
  String testQuestionProgress(int current, int total) {
    return '$current of $total questions';
  }

  @override
  String testAccuracy(int accuracy) {
    return 'Accuracy: $accuracy%';
  }

  @override
  String testPracticeMistakesCount(int count) {
    return 'Practice Mistakes ($count)';
  }

  @override
  String get testGoHome => 'Go Home';

  @override
  String get testMistakesToReview => 'Mistakes to Review:';

  @override
  String get testDragHint => 'Drag the correct article:';

  @override
  String get testChooseFrom => 'Choose from:';

  @override
  String get testCorrect => 'Correct!';

  @override
  String get testIncorrect => 'Incorrect!';

  @override
  String get statsYourProgress => 'Your Progress';

  @override
  String get statsSubtitle => 'See how far you\'ve come';

  @override
  String get statsProgress => 'Progress';

  @override
  String get statsNotStarted => 'Ready to start';

  @override
  String get statsErrorTitle => 'Unable to Load Statistics';

  @override
  String get statsErrorMessage =>
      'There was a problem loading your progress data. Please check your connection and try again.';

  @override
  String get statsGoBack => 'Go Back';

  @override
  String get statsOverall => 'Overall Statistics';

  @override
  String get statsTopics => 'Topics';

  @override
  String get statsAvgAccuracy => 'Avg Accuracy';

  @override
  String get statsCardsTotal => 'Cards Total';

  @override
  String get statsToReview => 'To Review';

  @override
  String get statsMaster => 'Master!';

  @override
  String get statsMasterMessage =>
      'Excellent work! You\'re mastering German articles!';

  @override
  String get statsGreatProgress => 'Great Progress!';

  @override
  String get statsGreatProgressMessage =>
      'You\'re doing really well! Keep it up!';

  @override
  String get statsGoodStart => 'Good Start!';

  @override
  String get statsGoodStartMessage =>
      'You\'re making progress! Practice makes perfect.';

  @override
  String get statsKeepLearning => 'Keep Learning!';

  @override
  String get statsKeepLearningMessage =>
      'Every expert was once a beginner. Keep going!';

  @override
  String get statsTopicBreakdown => 'Topic Breakdown';

  @override
  String statsAccuracyLabel(int percent) {
    return 'Accuracy: $percent%';
  }

  @override
  String statsToReviewCount(int count) {
    return '$count to review';
  }

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
