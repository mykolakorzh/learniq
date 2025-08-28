import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/topics/view/topics_screen.dart';
import 'features/topics/view/topic_detail_screen.dart';
import 'features/learn/learn_screen.dart';
import 'features/test/test_screen.dart';
import 'features/paywall/paywall_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'topics',
        builder: (context, state) => const TopicsScreen(),
      ),
      GoRoute(
        path: '/topic/:id',
        name: 'topic_detail',
        builder: (context, state) {
          final topicId = state.pathParameters['id']!;
          return TopicDetailScreen(topicId: topicId);
        },
      ),
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/learn/:topicId',
        name: 'learn',
        builder: (context, state) {
          final topicId = state.pathParameters['topicId']!;
          return LearnScreen(topicId: topicId);
        },
      ),
      GoRoute(
        path: '/test/:topicId',
        name: 'test',
        builder: (context, state) {
          final topicId = state.pathParameters['topicId']!;
          return TestScreen(topicId: topicId);
        },
      ),
    ],
  );
} 