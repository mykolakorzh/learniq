import 'package:flutter/material.dart';
import '../../features/topics/view/topics_screen.dart';
import '../../screens/learn_screen.dart';
import '../../screens/test_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const TopicsScreen());
      case '/learn':
        final topicId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => LearnScreen(topicId: topicId),
        );
      case '/test':
        final topicId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TestScreen(topicId: topicId),
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