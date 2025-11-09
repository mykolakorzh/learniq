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
  String get statisticsTitle => 'Статистика';

  @override
  String get learnModeTitle => 'Режим изучения';

  @override
  String get testModeTitle => 'Режим теста';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingGetStarted => 'Начать';

  @override
  String get onboardingPage1Title => 'Освойте немецкие артикли';

  @override
  String get onboardingPage1Description =>
      'Изучайте der, die и das с помощью красивых визуальных карточек с изображениями, которые помогут вам запомнить.';

  @override
  String get onboardingPage2Title => 'Интерактивные тесты';

  @override
  String get onboardingPage2Description =>
      'Проверьте свои знания с помощью забавных тестов с перетаскиванием. Получайте мгновенную обратную связь и отслеживайте свои ошибки.';

  @override
  String get onboardingPage3Title => 'Идеальное произношение';

  @override
  String get onboardingPage3Description =>
      'Слушайте native немецкое произношение с помощью синтеза речи. Практикуйте аудирование и говорение.';

  @override
  String get onboardingPage4Title => 'Отслеживайте свой прогресс';

  @override
  String get onboardingPage4Description =>
      'Следите за своим обучением с помощью подробной статистики и значков достижений.';

  @override
  String get splashAppName => 'LearnIQ';

  @override
  String get splashTagline => 'Освойте немецкие артикли';

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
  String settingsClearProgressError(String error) {
    return 'Не удалось очистить прогресс: $error';
  }

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
  String get topicsRetry => 'Повторить';

  @override
  String topicsError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get topicsPremium => 'Премиум';

  @override
  String get topicsAll => 'Все';

  @override
  String get topicsSearchHint => 'Поиск тем...';

  @override
  String get topicsSubtitle => 'Начните свое обучение';

  @override
  String get topicsNoTopicsFound => 'Темы не найдены';

  @override
  String get topicsAdjustFilters => 'Попробуйте другой поисковый запрос';

  @override
  String get topicsClearFilters => 'Очистить фильтры';

  @override
  String get topicsPreview => 'Примеры';

  @override
  String get learnLoading => 'Загрузка карточек для изучения...';

  @override
  String get learnErrorTitle => 'Не удалось загрузить карточки';

  @override
  String get learnErrorMessage =>
      'Произошла проблема при загрузке карточек для изучения. Пожалуйста, попробуйте снова.';

  @override
  String get learnNoCardsTitle => 'Нет доступных карточек';

  @override
  String get learnNoCardsMessage =>
      'В этой теме пока нет карточек для изучения.';

  @override
  String get learnCongratulations => 'Поздравляем!';

  @override
  String learnCompletedCards(int count) {
    return 'Вы завершили все $count карточек!';
  }

  @override
  String learnCardProgress(int current, int total) {
    return '$current из $total карточек';
  }

  @override
  String get learnSwipeHint => 'Смахните влево или вправо для навигации';

  @override
  String get learnTapToReveal => 'Нажмите, чтобы увидеть перевод';

  @override
  String get learnTapToFlipBack => 'Нажмите, чтобы вернуться';

  @override
  String get learnHearPronunciation => 'Прослушать произношение';

  @override
  String get testLoading => 'Загрузка карточек для теста...';

  @override
  String get testNoCardsTitle => 'Нет доступных карточек';

  @override
  String get testNoCardsMessage => 'Нет доступных карточек для этой темы.';

  @override
  String get testReviewComplete => 'Повтор завершен!';

  @override
  String get testTestComplete => 'Тест завершен!';

  @override
  String testQuestionProgress(int current, int total) {
    return '$current из $total вопросов';
  }

  @override
  String testAccuracy(int accuracy) {
    return 'Точность: $accuracy%';
  }

  @override
  String testPracticeMistakesCount(int count) {
    return 'Практика ошибок ($count)';
  }

  @override
  String get testGoHome => 'На главную';

  @override
  String get testMistakesToReview => 'Ошибки для повтора:';

  @override
  String get testDragHint => 'Перетащите правильный артикль:';

  @override
  String get testChooseFrom => 'Выберите из:';

  @override
  String get testCorrect => 'Правильно!';

  @override
  String get testIncorrect => 'Неправильно!';

  @override
  String get statsYourProgress => 'Ваш прогресс';

  @override
  String get statsSubtitle => 'Смотрите, как далеко вы продвинулись';

  @override
  String get statsProgress => 'Прогресс';

  @override
  String get statsNotStarted => 'Готов к старту';

  @override
  String get statsErrorTitle => 'Не удалось загрузить статистику';

  @override
  String get statsErrorMessage =>
      'Произошла проблема при загрузке данных о вашем прогрессе. Пожалуйста, проверьте подключение и попробуйте снова.';

  @override
  String get statsGoBack => 'Назад';

  @override
  String get statsOverall => 'Общая статистика';

  @override
  String get statsTopics => 'Темы';

  @override
  String get statsAvgAccuracy => 'Средняя точность';

  @override
  String get statsCardsTotal => 'Всего карточек';

  @override
  String get statsToReview => 'Для повтора';

  @override
  String get statsMaster => 'Мастер!';

  @override
  String get statsMasterMessage =>
      'Отличная работа! Вы осваиваете немецкие артикли!';

  @override
  String get statsGreatProgress => 'Отличный прогресс!';

  @override
  String get statsGreatProgressMessage =>
      'Вы очень хорошо справляетесь! Продолжайте!';

  @override
  String get statsGoodStart => 'Хорошее начало!';

  @override
  String get statsGoodStartMessage =>
      'Вы делаете успехи! Практика делает совершенным.';

  @override
  String get statsKeepLearning => 'Продолжайте учиться!';

  @override
  String get statsKeepLearningMessage =>
      'Каждый эксперт когда-то был новичком. Продолжайте!';

  @override
  String get statsTopicBreakdown => 'Разбивка по темам';

  @override
  String statsAccuracyLabel(int percent) {
    return 'Точность: $percent%';
  }

  @override
  String statsToReviewCount(int count) {
    return '$count для повтора';
  }

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
