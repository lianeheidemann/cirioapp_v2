import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppLoadingList extends StatelessWidget {
  final int count;
  const AppLoadingList({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, __) => Container(
          height: 132,
          decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(color: AppColors.divider)),
          padding: const EdgeInsets.all(AppSpacing.md),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _bar(90, 14),
            const SizedBox(height: 16),
            _bar(double.infinity, 18),
            const SizedBox(height: 10),
            _bar(210, 14),
            const Spacer(),
            _bar(140, 12),
          ]),
        ),
      );

  Widget _bar(double width, double height) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: AppColors.divider.withValues(alpha: .65),
            borderRadius: BorderRadius.circular(8)),
      );
}
