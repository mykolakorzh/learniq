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
  String get statisticsTitle => 'Статистика';

  @override
  String get learnModeTitle => 'Режим вивчення';

  @override
  String get testModeTitle => 'Режим тесту';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingNext => 'Далі';

  @override
  String get onboardingGetStarted => 'Почати';

  @override
  String get onboardingPage1Title => 'Опануйте німецькі артиклі';

  @override
  String get onboardingPage1Description =>
      'Вивчайте der, die та das за допомогою красивих візуальних карток із зображеннями, які допоможуть вам запам\'ятати.';

  @override
  String get onboardingPage2Title => 'Інтерактивні тести';

  @override
  String get onboardingPage2Description =>
      'Перевірте свої знання за допомогою веселих тестів з перетягуванням. Отримуйте миттєвий зворотний зв\'язок і відстежуйте свої помилки.';

  @override
  String get onboardingPage3Title => 'Ідеальна вимова';

  @override
  String get onboardingPage3Description =>
      'Слухайте природну німецьку вимову за допомогою синтезу мови. Практикуйте аудіювання та говоріння.';

  @override
  String get onboardingPage4Title => 'Відстежуйте свій прогрес';

  @override
  String get onboardingPage4Description =>
      'Стежте за своїм навчанням за допомогою детальної статистики та значків досягнень.';

  @override
  String get splashAppName => 'LearnIQ';

  @override
  String get splashTagline => 'Опануйте німецькі артиклі';

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
  String settingsClearProgressError(String error) {
    return 'Не вдалося очистити прогрес: $error';
  }

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
  String get topicsRetry => 'Повторити';

  @override
  String topicsError(String error) {
    return 'Помилка: $error';
  }

  @override
  String get topicsPremium => 'Преміум';

  @override
  String get topicsAll => 'Всі';

  @override
  String get topicsSearchHint => 'Пошук тем...';

  @override
  String get topicsSubtitle => 'Почніть своє навчання';

  @override
  String get topicsNoTopicsFound => 'Теми не знайдено';

  @override
  String get topicsAdjustFilters => 'Спробуйте інший пошуковий запит';

  @override
  String get topicsClearFilters => 'Очистити фільтри';

  @override
  String get topicsPreview => 'Приклади';

  @override
  String get learnLoading => 'Завантаження карток для вивчення...';

  @override
  String get learnErrorTitle => 'Не вдалося завантажити картки';

  @override
  String get learnErrorMessage =>
      'Виникла проблема при завантаженні карток для вивчення. Будь ласка, спробуйте ще раз.';

  @override
  String get learnNoCardsTitle => 'Немає доступних карток';

  @override
  String get learnNoCardsMessage =>
      'У цій темі поки немає карток для вивчення.';

  @override
  String get learnCongratulations => 'Вітаємо!';

  @override
  String learnCompletedCards(int count) {
    return 'Ви завершили всі $count карток!';
  }

  @override
  String learnCardProgress(int current, int total) {
    return '$current з $total карток';
  }

  @override
  String get learnSwipeHint => 'Змахніть вліво або вправо для навігації';

  @override
  String get learnTapToReveal => 'Натисніть, щоб побачити переклад';

  @override
  String get learnTapToFlipBack => 'Натисніть, щоб повернутися';

  @override
  String get learnHearPronunciation => 'Прослухати вимову';

  @override
  String get testLoading => 'Завантаження карток для тесту...';

  @override
  String get testNoCardsTitle => 'Немає доступних карток';

  @override
  String get testNoCardsMessage => 'Немає доступних карток для цієї теми.';

  @override
  String get testReviewComplete => 'Повтор завершено!';

  @override
  String get testTestComplete => 'Тест завершено!';

  @override
  String testQuestionProgress(int current, int total) {
    return '$current з $total питань';
  }

  @override
  String testAccuracy(int accuracy) {
    return 'Точність: $accuracy%';
  }

  @override
  String testPracticeMistakesCount(int count) {
    return 'Практика помилок ($count)';
  }

  @override
  String get testGoHome => 'На головну';

  @override
  String get testMistakesToReview => 'Помилки для повтору:';

  @override
  String get testDragHint => 'Перетягніть правильний артикль:';

  @override
  String get testChooseFrom => 'Виберіть з:';

  @override
  String get testCorrect => 'Правильно!';

  @override
  String get testIncorrect => 'Неправильно!';

  @override
  String get statsYourProgress => 'Ваш прогрес';

  @override
  String get statsSubtitle => 'Дивіться, як далеко ви просунулися';

  @override
  String get statsProgress => 'Прогрес';

  @override
  String get statsNotStarted => 'Готовий до старту';

  @override
  String get statsErrorTitle => 'Не вдалося завантажити статистику';

  @override
  String get statsErrorMessage =>
      'Виникла проблема при завантаженні даних про ваш прогрес. Будь ласка, перевірте підключення і спробуйте знову.';

  @override
  String get statsGoBack => 'Назад';

  @override
  String get statsOverall => 'Загальна статистика';

  @override
  String get statsTopics => 'Теми';

  @override
  String get statsAvgAccuracy => 'Середня точність';

  @override
  String get statsCardsTotal => 'Всього карток';

  @override
  String get statsToReview => 'Для повтору';

  @override
  String get statsMaster => 'Майстер!';

  @override
  String get statsMasterMessage =>
      'Чудова робота! Ви опановуєте німецькі артиклі!';

  @override
  String get statsGreatProgress => 'Чудовий прогрес!';

  @override
  String get statsGreatProgressMessage =>
      'Ви дуже добре справляєтесь! Продовжуйте!';

  @override
  String get statsGoodStart => 'Гарний початок!';

  @override
  String get statsGoodStartMessage =>
      'Ви робите успіхи! Практика робить досконалим.';

  @override
  String get statsKeepLearning => 'Продовжуйте вчитися!';

  @override
  String get statsKeepLearningMessage =>
      'Кожен експерт колись був новачком. Продовжуйте!';

  @override
  String get statsTopicBreakdown => 'Розбивка за темами';

  @override
  String statsAccuracyLabel(int percent) {
    return 'Точність: $percent%';
  }

  @override
  String statsToReviewCount(int count) {
    return '$count для повтору';
  }

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
