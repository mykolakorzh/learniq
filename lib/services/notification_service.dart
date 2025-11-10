import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'spaced_repetition_service.dart';

/// Service for managing local push notifications
///
/// Features:
/// - Daily study reminders at customizable times
/// - Smart notifications based on due cards
/// - Permission handling for iOS/Android
/// - User preference management
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // SharedPreferences keys
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationTimeKey = 'notification_time'; // Format: "HH:mm"

  // Default settings
  static const String _defaultNotificationTime = '19:00'; // 7 PM
  static const int _dailyNotificationId = 1;

  /// Initialize the notification service
  ///
  /// Must be called once at app startup
  static Future<void> initialize() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // We'll request manually
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Future: Navigate to specific screen when notification is tapped
    // For now, just log (app will open normally)
  }

  /// Request notification permissions
  ///
  /// Returns true if granted, false otherwise
  static Future<bool> requestPermissions() async {
    // Request iOS permissions
    final iosGranted = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request Android permissions (Android 13+)
    final androidGranted = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return iosGranted == true || androidGranted == true;
  }

  /// Check if notifications are enabled in settings
  static Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  /// Enable or disable notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);

    if (enabled) {
      // Request permissions if not already granted
      final granted = await requestPermissions();
      if (granted) {
        await scheduleDailyNotification();
      }
    } else {
      await cancelAllNotifications();
    }
  }

  /// Get notification time (HH:mm format)
  static Future<String> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_notificationTimeKey) ?? _defaultNotificationTime;
  }

  /// Set notification time (HH:mm format)
  static Future<void> setNotificationTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationTimeKey, time);

    // Reschedule notification with new time
    if (await areNotificationsEnabled()) {
      await scheduleDailyNotification();
    }
  }

  /// Schedule daily notification at the configured time
  static Future<void> scheduleDailyNotification() async {
    // Cancel existing notifications first
    await _notifications.cancel(_dailyNotificationId);

    final timeString = await getNotificationTime();
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Get current time in local timezone
    final location = tz.getLocation('America/New_York'); // Using a common timezone
    final now = tz.TZDateTime.now(location);

    // Create notification time for today
    var scheduledDate = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Get personalized message
    final message = await _getNotificationMessage();

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Daily Study Reminders',
      channelDescription: 'Reminds you to practice German every day',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    // iOS notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule the notification
    await _notifications.zonedSchedule(
      _dailyNotificationId,
      'Time to practice German!',
      message,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  /// Get personalized notification message based on user progress
  static Future<String> _getNotificationMessage() async {
    try {
      // Count total due cards across all topics
      // For now, use a motivational message
      // Future: integrate with due cards count

      final messages = [
        'Your daily German practice is waiting!',
        'Keep your streak alive! Practice now.',
        'A few minutes of practice makes a big difference!',
        'Ready to learn some German today?',
        'Your brain is ready for new German words!',
      ];

      // Use day of week to select message (consistent per day)
      final dayIndex = DateTime.now().weekday % messages.length;
      return messages[dayIndex];
    } catch (e) {
      return 'Time for your daily German practice!';
    }
  }

  /// Cancel all scheduled notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Get pending notifications (for debugging)
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Show immediate test notification
  static Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999,
      'Test Notification',
      'This is a test notification from LearnIQ!',
      details,
    );
  }
}
