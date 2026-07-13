import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';

class NotificationsLocalStorage {
  static const _storageKey = 'received_notifications';
  static const _maximumItems = 100;

  Future<List<AppNotification>> load() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final encoded = preferences.getStringList(_storageKey) ?? const [];

    return encoded
        .map((item) {
          try {
            return AppNotification.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<AppNotification>()
        .toList();
  }

  Future<List<AppNotification>> add(AppNotification notification) async {
    final notifications = await load();
    notifications.removeWhere((item) => item.id == notification.id);
    notifications.insert(0, notification);
    if (notifications.length > _maximumItems) {
      notifications.removeRange(_maximumItems, notifications.length);
    }
    await _save(notifications);
    return notifications;
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }

  Future<void> _save(List<AppNotification> notifications) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      notifications.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
}
