import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// AppBar padrão do app com gradiente azul.
///
/// Implementa [PreferredSizeWidget] para ser usado como [AppBar].
/// Aceita [actions] opcionais (ex: botão de favoritar).
class CirioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CirioAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryBlue, Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
