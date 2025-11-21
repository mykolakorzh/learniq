import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'routing/app_router.dart';

/// Global error handler for the app
class AppErrorHandler {
  /// Initialize error handling
  static void initialize() {
    // Flutter framework errors are already handled in main.dart
    // This is for additional error handling if needed
  }

  /// Handle and log an error
  static void handleError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('Error: $error');
      debugPrint('Stack: $stackTrace');
      if (reason != null) {
        debugPrint('Reason: $reason');
      }
    }

    // Log to Crashlytics
    try {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      // Crashlytics not available - that's okay
      debugPrint('Failed to log to Crashlytics: $e');
    }
  }

  /// Show a user-friendly error message
  static void showError(BuildContext context, String message, {VoidCallback? onRetry}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  /// Show a user-friendly error dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onRetry,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                SafeNavigation.pop(context);
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => SafeNavigation.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

