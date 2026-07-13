import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';

import '../../core/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? title;
  final VoidCallback? onRetry;

  const EmptyStateWidget(
      {super.key,
      required this.icon,
      required this.message,
      this.title,
      this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                  color: AppColors.softBlue, shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: AppColors.secondaryBlue),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
                title ?? tr(context, 'Nada por aqui ainda', 'Nothing here yet'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.muted)),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(tr(context, 'Tentar novamente', 'Try again'))),
            ],
          ]),
        ),
      );
}
