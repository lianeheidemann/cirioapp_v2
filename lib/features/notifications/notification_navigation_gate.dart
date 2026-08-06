import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/app_notification.dart';
import '../news/news_detail_screen.dart';
import '../news/news_provider.dart';
import 'notifications_provider.dart';
import 'notifications_screen.dart';

/// Navega para o conteúdo relacionado quando o usuário toca numa notificação.
///
/// Notificações com `data: {type: 'news', newsId: '...'}` abrem a notícia
/// correspondente, caso já esteja carregada em [NewsProvider]. Qualquer outro
/// caso — payload sem esses campos, notícia ainda não carregada, ou app
/// aberto a partir do histórico local — cai para a tela de Notificações.
class NotificationNavigationGate extends StatefulWidget {
  final Widget child;

  const NotificationNavigationGate({super.key, required this.child});

  @override
  State<NotificationNavigationGate> createState() =>
      _NotificationNavigationGateState();
}

class _NotificationNavigationGateState
    extends State<NotificationNavigationGate> {
  StreamSubscription<AppNotification>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<NotificationsProvider>();
      final pending = provider.consumePendingTap();
      if (pending != null) _open(pending);
      _subscription = provider.onNotificationTapped.listen(_open);
    });
  }

  void _open(AppNotification notification) {
    if (!mounted) return;
    final newsId = notification.data['newsId'];
    if (notification.data['type'] == 'news' && newsId != null) {
      final news = context.read<NewsProvider>().news;
      for (final article in news) {
        if (article.id == newsId) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewsDetailScreen(news: article)),
          );
          return;
        }
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
