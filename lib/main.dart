import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/subscription_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize notification service
  await NotificationService.initialize();

  // Initialize subscription service (RevenueCat)
  await SubscriptionService.getInstance();

  // TODO: Initialize Firebase
  // Will be added after Firebase setup

  runApp(const LearniqApp());
}