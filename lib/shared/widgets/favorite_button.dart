import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';

import '../../core/theme/app_theme.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final bool onDark;

  const FavoriteButton(
      {super.key,
      required this.isFavorite,
      required this.onTap,
      this.onDark = false});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onTap,
        tooltip: isFavorite
            ? tr(context, 'Remover dos favoritos', 'Remove from favorites')
            : tr(context, 'Adicionar aos favoritos', 'Add to favorites'),
        style: IconButton.styleFrom(
          backgroundColor:
              onDark ? Colors.white.withValues(alpha: .12) : AppColors.softGold,
          foregroundColor: isFavorite
              ? AppColors.gold
              : (onDark ? Colors.white : AppColors.navy),
        ),
        icon: Icon(isFavorite
            ? Icons.favorite_rounded
            : Icons.favorite_border_rounded),
      );
}
