import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

/// Widget raiz do MaterialApp.
///
/// Aplica o tema claro customizado (azul e dourado) e define a tela inicial
/// como [HomeScreen]. O [MultiProvider] já está configurado em [main].
class CirioApp extends StatelessWidget {
  const CirioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CírioApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
