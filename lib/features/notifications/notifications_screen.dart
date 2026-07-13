import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_language.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/app_notification.dart';
import '../../data/services/firebase_notifications_service.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'notifications_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    return Scaffold(
      appBar: CirioAppBar(
        title: tr(context, 'Notificações', 'Notifications'),
        subtitle: tr(
          context,
          'Avisos importantes do Círio',
          'Important Círio alerts',
        ),
        actions: provider.notifications.isEmpty
            ? null
            : [
                IconButton(
                  tooltip: tr(context, 'Limpar notificações', 'Clear alerts'),
                  onPressed: () => _confirmClear(context, provider),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
                const SizedBox(width: 4),
              ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    sliver: SliverToBoxAdapter(
                      child: _PermissionCard(provider: provider),
                    ),
                  ),
                  if (provider.errorMessage != null)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          tr(
                            context,
                            'Não foi possível atualizar as notificações.',
                            'Notifications could not be updated.',
                          ),
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  if (provider.notifications.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateWidget(
                        icon: Icons.notifications_none_rounded,
                        title: tr(
                          context,
                          'Nenhuma notificação',
                          'No notifications',
                        ),
                        message: tr(
                          context,
                          'Os avisos recebidos aparecerão aqui.',
                          'Received alerts will appear here.',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      sliver: SliverList.separated(
                        itemCount: provider.notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) => _NotificationCard(
                          notification: provider.notifications[index],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    NotificationsProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title:
            Text(tr(context, 'Limpar notificações?', 'Clear notifications?')),
        content: Text(tr(
          context,
          'O histórico salvo neste aparelho será removido.',
          'The history saved on this device will be removed.',
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(tr(context, 'Cancelar', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(tr(context, 'Limpar', 'Clear')),
          ),
        ],
      ),
    );
    if (confirmed == true) await provider.clear();
  }
}

class _PermissionCard extends StatelessWidget {
  final NotificationsProvider provider;

  const _PermissionCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final enabled = provider.permission == NotificationsPermission.authorized ||
        provider.permission == NotificationsPermission.provisional;
    final title = !provider.isAvailable
        ? tr(context, 'Firebase não configurado', 'Firebase is not configured')
        : enabled
            ? tr(context, 'Notificações ativadas', 'Notifications enabled')
            : tr(context, 'Ative as notificações', 'Enable notifications');
    final message = !provider.isAvailable
        ? tr(
            context,
            'Conecte este app a um projeto Firebase para receber avisos.',
            'Connect this app to Firebase to receive alerts.',
          )
        : enabled
            ? tr(
                context,
                'Você receberá avisos e orientações importantes.',
                'You will receive important alerts and guidance.',
              )
            : tr(
                context,
                'Permita avisos para acompanhar atualizações importantes.',
                'Allow alerts to follow important updates.',
              );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: enabled ? AppColors.softBlue : AppColors.softGold,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            enabled
                ? Icons.notifications_active_outlined
                : Icons.notifications_none_rounded,
            color: enabled ? AppColors.secondaryBlue : AppColors.gold,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
                if (provider.isAvailable && !enabled) ...[
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: provider.enableNotifications,
                    child: Text(tr(context, 'Ativar', 'Enable')),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final date = notification.receivedAt.toLocal();
    final localizations = MaterialLocalizations.of(context);
    final timestamp = '${localizations.formatShortDate(date)} - '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(date))}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.divider),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.softGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: AppColors.gold,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (notification.body.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(notification.body),
                ],
                const SizedBox(height: 8),
                Text(timestamp, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
