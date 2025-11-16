import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'services/settings_service.dart';
import 'services/analytics_service.dart';

class LearniqApp extends StatefulWidget {
  const LearniqApp({super.key});

  // Global key to access app state from anywhere
  static final GlobalKey<_LearniqAppState> appKey = GlobalKey<_LearniqAppState>();

  @override
  State<LearniqApp> createState() => _LearniqAppState();

  // Static method to change language from anywhere in the app
  static void setLocale(BuildContext context, String languageCode) {
    final state = context.findAncestorStateOfType<_LearniqAppState>();
    state?.setLocale(languageCode);
  }
}

class _LearniqAppState extends State<LearniqApp> {
  Locale _locale = const Locale('ru', '');

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final languageCode = await SettingsService.getLanguage();
    setState(() {
      _locale = Locale(languageCode, '');
    });
  }

  void setLocale(String languageCode) {
    setState(() {
      _locale = Locale(languageCode, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learniq',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: _locale, // Apply the selected locale
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
        Locale('uk', ''),
      ],
      navigatorObservers: [
        // Add analytics observer if available
        if (AnalyticsService.observer != null) AnalyticsService.observer!,
      ],
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}