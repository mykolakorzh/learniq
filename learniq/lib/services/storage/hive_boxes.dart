import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const String progressBox = 'progress';
  static const String settingsBox = 'settings';
  static const String userDataBox = 'user_data';

  static Future<void> initializeBoxes() async {
    await Hive.openBox(progressBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox(userDataBox);
  }

  static Box getProgressBox() {
    return Hive.box(progressBox);
  }

  static Box getSettingsBox() {
    return Hive.box(settingsBox);
  }

  static Box getUserDataBox() {
    return Hive.box(userDataBox);
  }

  static Future<void> closeBoxes() async {
    await Hive.close();
  }
} 