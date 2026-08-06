import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/local/notifications_local_storage.dart';
import '../../data/models/app_notification.dart';
import '../../data/services/firebase_notifications_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsLocalStorage _storage;
  final FirebaseNotificationsService? _service;
  final List<StreamSubscription<AppNotification>> _subscriptions = [];
  final _tapController = StreamController<AppNotification>.broadcast();

  NotificationsProvider(this._storage, this._service);

  List<AppNotification> _notifications = const [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  bool get hasUnread => _notifications.any((n) => !n.isRead);

  /// Notificação com a qual o app foi aberto (app encerrado), consumida uma
  /// única vez por [consumePendingTap]. Necessária porque [initialize] roda
  /// antes de `runApp`, então nenhum listener do widget tree ainda existe
  /// para captar um evento emitido diretamente em [onNotificationTapped].
  AppNotification? _pendingInitialTap;

  /// Emitida quando o usuário toca numa notificação (push aberto com o app em
  /// segundo plano, ou banner local tocado) para quem decide a navegação.
  Stream<AppNotification> get onNotificationTapped => _tapController.stream;

  AppNotification? consumePendingTap() {
    final pending = _pendingInitialTap;
    _pendingInitialTap = null;
    return pending;
  }

  NotificationsPermission _permission = NotificationsPermission.notDetermined;
  NotificationsPermission get permission => _permission;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool get isAvailable => _service != null;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    try {
      _notifications = await _storage.load();
      final service = _service;
      if (service != null) {
        _permission = await service.permission();
        _subscriptions
          ..add(service.onForegroundMessage.listen(_receive))
          ..add(service.onNotificationOpened.listen(_handleTap))
          ..add(service.onLocalNotificationTapped.listen(_handleTap));
        final initial = await service.getInitialNotification();
        if (initial != null) {
          await _receive(initial);
          _pendingInitialTap = initial;
        }
      }
    } catch (_) {
      _errorMessage = 'Não foi possível carregar as notificações.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> enableNotifications() async {
    final service = _service;
    if (service == null) return;
    _errorMessage = null;
    try {
      _permission = await service.requestPermission();
    } catch (_) {
      _errorMessage = 'Não foi possível ativar as notificações.';
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    _notifications = await _storage.load();
    notifyListeners();
  }

  Future<void> clear() async {
    await _storage.clear();
    _notifications = const [];
    notifyListeners();
  }

  Future<void> markAllRead() async {
    if (!hasUnread) return;
    _notifications = _notifications
        .map((n) => n.isRead ? n : n.copyWith(isRead: true))
        .toList();
    await _storage.save(_notifications);
    notifyListeners();
  }

  Future<void> _receive(AppNotification notification) async {
    _notifications = await _storage.add(notification);
    notifyListeners();
  }

  Future<void> _handleTap(AppNotification notification) async {
    await _receive(notification);
    _tapController.add(notification);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    unawaited(_tapController.close());
    super.dispose();
  }
}
