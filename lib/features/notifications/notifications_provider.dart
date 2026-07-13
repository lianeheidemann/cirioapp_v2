import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/local/notifications_local_storage.dart';
import '../../data/models/app_notification.dart';
import '../../data/services/firebase_notifications_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsLocalStorage _storage;
  final FirebaseNotificationsService? _service;
  final List<StreamSubscription<AppNotification>> _subscriptions = [];

  NotificationsProvider(this._storage, this._service);

  List<AppNotification> _notifications = const [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

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
          ..add(service.onNotificationOpened.listen(_receive));
        final initial = await service.getInitialNotification();
        if (initial != null) await _receive(initial);
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

  Future<void> _receive(AppNotification notification) async {
    _notifications = await _storage.add(notification);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
