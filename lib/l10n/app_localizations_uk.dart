// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Learniq';

  @override
  String get topicsTitle => 'Теми';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsAppPreferences => 'Налаштування програми';

  @override
  String get settingsSoundEffects => 'Звукові ефекти';

  @override
  String get settingsSoundEffectsSubtitle => 'Відтворювати звуки при взаємодії';

  @override
  String get settingsHapticFeedback => 'Вібрація';

  @override
  String get settingsHapticFeedbackSubtitle => 'Вібрувати при взаємодії';

  @override
  String get settingsTts => 'Озвучування тексту';

  @override
  String get settingsTtsSubtitle => 'Увімкнути аудіо вимову';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageUkrainian => 'Українська';

  @override
  String get settingsLanguageChanged => 'Мову змінено';

  @override
  String get settingsLanguageChangedRu => 'Язык изменен';

  @override
  String get settingsLanguageChangedUk => 'Мову змінено';

  @override
  String get settingsData => 'Дані';

  @override
  String get settingsClearProgress => 'Очистити прогрес';

  @override
  String get settingsClearProgressSubtitle => 'Скинути весь прогрес навчання';

  @override
  String get settingsResetToDefaults => 'Скинути налаштування';

  @override
  String get settingsResetToDefaultsSubtitle =>
      'Відновити налаштування за замовчуванням';

  @override
  String get settingsAbout => 'Про програму';

  @override
  String get settingsVersion => 'Версія';

  @override
  String get settingsDeveloper => 'Розробник';

  @override
  String get settingsDeveloperName => 'Микола Корж';

  @override
  String get settingsPrivacyPolicy => 'Політика конфіденційності';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Переглянути політику конфіденційності';

  @override
  String get settingsPrivacyPolicyMessage =>
      'Політика конфіденційності відкриється тут';

  @override
  String get settingsLicense => 'Ліцензія';

  @override
  String get settingsLicenseSubtitle => 'Пропрієтарна - Всі права захищені';

  @override
  String get settingsClearProgressDialogTitle => 'Очистити весь прогрес?';

  @override
  String get settingsClearProgressDialogMessage =>
      'Це видалить весь ваш прогрес навчання та статистику. Цю дію не можна скасувати.';

  @override
  String get settingsClearProgressDialogConfirm => 'Очистити';

  @override
  String get settingsClearProgressDialogCancel => 'Скасувати';

  @override
  String get settingsClearProgressSuccess => 'Прогрес очищено';

  @override
  String get settingsResetDialogTitle => 'Скинути налаштування?';

  @override
  String get settingsResetDialogMessage =>
      'Це відновить всі налаштування до значень за замовчуванням.';

  @override
  String get settingsResetDialogConfirm => 'Скинути';

  @override
  String get settingsResetDialogCancel => 'Скасувати';

  @override
  String get settingsResetSuccess => 'Налаштування скинуто';

  @override
  String get topicsFailedToLoad => 'Не вдалося завантажити теми';

  @override
  String get topicsCards => 'карток';

  @override
  String topicsCardCount(int count) {
    return '$count карток';
  }

  @override
  String get topicsProgress => 'Прогрес';

  @override
  String get topicsMistakes => 'Помилки';

  @override
  String get topicsFree => 'Безкоштовно';

  @override
  String get topicsFixMistakes => 'Виправити помилки';

  @override
  String get topicsChooseLearningMode => 'Виберіть режим навчання';

  @override
  String get topicsYourProgress => 'Ваш прогрес';

  @override
  String get topicsPracticeMistakes => 'Практика помилок';

  @override
  String topicsPracticeMistakesFocus(int count) {
    return 'Зосередьтеся на слабких словах ($count)';
  }

  @override
  String get topicsLearn => 'Вивчати';

  @override
  String get topicsLearnSubtitle => 'Вивчати словникові картки';

  @override
  String get topicsTest => 'Тестувати';

  @override
  String get topicsTestSubtitle => 'Практика з вікториною';

  @override
  String get paywallTitle => 'Преміум';

  @override
  String get paywallComingSoon => 'Система підписки';

  @override
  String get paywallDescription =>
      'Преміум функції будуть доступні найближчим часом. Тут ви зможете розблокувати додаткові теми та функції.';

  @override
  String get paywallUnlockPremium => 'Розблокувати Преміум';

  @override
  String get paywallRestorePurchases => 'Відновити покупки';

  @override
  String get paywallBackToTopics => 'Повернутися до тем';
}
