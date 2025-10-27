// Temporarily commented out due to missing hive_flutter dependency
/*
import 'package:hive_flutter/hive_flutter.dart';

// Hive box names
const String progressBoxName = 'progress';
const String settingsBoxName = 'settings';
const String userDataBoxName = 'user_data';

// Hive box keys
const String lastAccuracyKey = 'last_accuracy';
const String mistakesKey = 'mistakes';
const String completedTopicsKey = 'completed_topics';
const String userPreferencesKey = 'user_preferences';

// Initialize Hive boxes
Future<void> initializeHiveBoxes() async {
  await Hive.openBox(progressBoxName);
  await Hive.openBox(settingsBoxName);
  await Hive.openBox(userDataBoxName);
}

// Get box instances
Box get progressBox => Hive.box(progressBoxName);
Box get settingsBox => Hive.box(settingsBoxName);
Box get userDataBox => Hive.box(userDataBoxName);

// Close all boxes
Future<void> closeHiveBoxes() async {
  await Hive.close();
}
*/