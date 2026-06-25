import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Botão de favoritar coração (preenchido/vazado).
///
/// Usa [AppTheme.accentGold] quando favoritado, cinza quando não.
/// Recebe [isFavorite] e [onTap] do provider da tela.
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? AppTheme.accentGold : Colors.grey,
      ),
      onPressed: onTap,
      tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
    );
  }
}
