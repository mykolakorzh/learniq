import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'router.dart';
import 'theme/theme.dart';

class ArtikeloApp extends StatelessWidget {
  const ArtikeloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Artikelo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
} 