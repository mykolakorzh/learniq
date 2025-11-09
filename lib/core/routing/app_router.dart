import 'package:flutter/material.dart';
import '../../screens/topics_screen.dart';
import '../../screens/learn_screen.dart';
import '../../screens/test_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/statistics_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/account_screen.dart';
import '../../screens/main_navigation_screen.dart';
import '../../widgets/animations.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/home':
        return PageTransitions.slideFromRight(const MainNavigationScreen());
      case '/statistics':
        return MaterialPageRoute(builder: (_) => const StatisticsScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/account':
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case '/learn':
        final topicId = settings.arguments as String;
        return PageTransitions.slideFromRight(
          LearnScreen(topicId: topicId),
        );
      case '/test':
        String topicId;
        bool startMistakesOnly = false;
        final args = settings.arguments;
        if (args is String) {
          topicId = args;
        } else if (args is Map) {
          topicId = args['topicId'] as String;
          startMistakesOnly = (args['mistakesOnly'] as bool?) ?? false;
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text('Invalid test arguments'))),
          );
        }
        return PageTransitions.slideFromRight(
          TestScreen(topicId: topicId, startMistakesOnly: startMistakesOnly),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}