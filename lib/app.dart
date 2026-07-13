import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/localization/app_language.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/permissions/startup_permissions_gate.dart';

class CirioApp extends StatelessWidget {
  const CirioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    return MaterialApp(
      title: 'CírioApp',
      locale: language.locale,
      supportedLocales: const [Locale('pt'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      scrollBehavior:
          const MaterialScrollBehavior().copyWith(overscroll: false),
      theme: AppTheme.lightTheme,
      home: const StartupPermissionsGate(
        child: HomeScreen(),
      ),
    );
  }
}
