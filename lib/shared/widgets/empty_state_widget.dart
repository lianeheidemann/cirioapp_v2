import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Widget de estado vazio para listas sem itens.
///
/// Exibe um [icon] grande e uma [message] centralizados.
/// Usado em: eventos vazios, locais sem resultado de filtro,
/// favoritos vazios, erros de carregamento.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textLight,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
