import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('progress');
  
  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('uk', 'UK'),
      ],
      path: 'assets/l10n',
      fallbackLocale: const Locale('ru', 'RU'),
      child: const ProviderScope(
        child: ArtikeloApp(),
      ),
    ),
  );
} 