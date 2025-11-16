import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/subscription_service.dart';
import 'services/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    
    // Initialize Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    // Pass non-fatal errors from the platform to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Initialize Analytics
    await AnalyticsService.initialize();
  } catch (e) {
    // Firebase initialization failed - app can still run without it
    // This allows the app to work in development without Firebase configured
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will continue without Firebase features');
  }

  // Initialize notification service
  await NotificationService.initialize();

  // Initialize subscription service (RevenueCat)
  await SubscriptionService.getInstance();

  runApp(const LearniqApp());
}