// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Learniq';

  @override
  String get topicsTitle => 'Темы';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAppPreferences => 'Настройки приложения';

  @override
  String get settingsSoundEffects => 'Звуковые эффекты';

  @override
  String get settingsSoundEffectsSubtitle =>
      'Воспроизводить звуки при взаимодействии';

  @override
  String get settingsHapticFeedback => 'Вибрация';

  @override
  String get settingsHapticFeedbackSubtitle => 'Вибрировать при взаимодействии';

  @override
  String get settingsTts => 'Озвучивание текста';

  @override
  String get settingsTtsSubtitle => 'Включить аудио произношение';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageUkrainian => 'Українська';

  @override
  String get settingsLanguageChanged => 'Язык изменен';

  @override
  String get settingsLanguageChangedRu => 'Язык изменен';

  @override
  String get settingsLanguageChangedUk => 'Мову змінено';

  @override
  String get settingsData => 'Данные';

  @override
  String get settingsClearProgress => 'Очистить прогресс';

  @override
  String get settingsClearProgressSubtitle => 'Сбросить весь прогресс обучения';

  @override
  String get settingsResetToDefaults => 'Сбросить настройки';

  @override
  String get settingsResetToDefaultsSubtitle =>
      'Восстановить настройки по умолчанию';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsDeveloper => 'Разработчик';

  @override
  String get settingsDeveloperName => 'Микола Корж';

  @override
  String get settingsPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Посмотреть политику конфиденциальности';

  @override
  String get settingsPrivacyPolicyMessage =>
      'Политика конфиденциальности откроется здесь';

  @override
  String get settingsLicense => 'Лицензия';

  @override
  String get settingsLicenseSubtitle => 'Проприетарная - Все права защищены';

  @override
  String get settingsClearProgressDialogTitle => 'Очистить весь прогресс?';

  @override
  String get settingsClearProgressDialogMessage =>
      'Это удалит весь ваш прогресс обучения и статистику. Это действие нельзя отменить.';

  @override
  String get settingsClearProgressDialogConfirm => 'Очистить';

  @override
  String get settingsClearProgressDialogCancel => 'Отмена';

  @override
  String get settingsClearProgressSuccess => 'Прогресс очищен';

  @override
  String get settingsResetDialogTitle => 'Сбросить настройки?';

  @override
  String get settingsResetDialogMessage =>
      'Это восстановит все настройки к значениям по умолчанию.';

  @override
  String get settingsResetDialogConfirm => 'Сбросить';

  @override
  String get settingsResetDialogCancel => 'Отмена';

  @override
  String get settingsResetSuccess => 'Настройки сброшены';

  @override
  String get topicsFailedToLoad => 'Не удалось загрузить темы';

  @override
  String get topicsCards => 'карточек';

  @override
  String topicsCardCount(int count) {
    return '$count карточек';
  }

  @override
  String get topicsProgress => 'Прогресс';

  @override
  String get topicsMistakes => 'Ошибки';

  @override
  String get topicsFree => 'Бесплатно';

  @override
  String get topicsFixMistakes => 'Исправить ошибки';

  @override
  String get topicsChooseLearningMode => 'Выберите режим обучения';

  @override
  String get topicsYourProgress => 'Ваш прогресс';

  @override
  String get topicsPracticeMistakes => 'Практика ошибок';

  @override
  String topicsPracticeMistakesFocus(int count) {
    return 'Сосредоточьтесь на слабых словах ($count)';
  }

  @override
  String get topicsLearn => 'Изучать';

  @override
  String get topicsLearnSubtitle => 'Изучать словарные карточки';

  @override
  String get topicsTest => 'Тестировать';

  @override
  String get topicsTestSubtitle => 'Практика с викториной';

  @override
  String get paywallTitle => 'Премиум';

  @override
  String get paywallComingSoon => 'Система подписки';

  @override
  String get paywallDescription =>
      'Премиум функции будут доступны в ближайшее время. Здесь вы сможете разблокировать дополнительные темы и функции.';

  @override
  String get paywallUnlockPremium => 'Разблокировать Премиум';

  @override
  String get paywallRestorePurchases => 'Восстановить покупки';

  @override
  String get paywallBackToTopics => 'Вернуться к темам';
}
