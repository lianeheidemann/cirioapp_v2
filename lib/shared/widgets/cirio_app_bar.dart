import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';

import '../../core/theme/app_theme.dart';

class CirioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const CirioAppBar(
      {super.key, required this.title, this.subtitle, this.actions});

  @override
  Widget build(BuildContext context) => AppBar(
        toolbarHeight: preferredSize.height,
        titleSpacing: 4,
        leadingWidth: 56,
        leading: Navigator.canPop(context)
            ? Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs),
                child: IconButton(
                  tooltip: tr(context, 'Voltar', 'Back'),
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
        actions: actions,
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      );

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 65 : 73);
}
