import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/app_notification.dart';

class LocalNotificationsService {
  static const channelId = 'cirio_alerts';
  static const _channelName = 'Avisos do Círio';
  static const _channelDescription =
      'Notícias, alertas e informações importantes do Círio.';

  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationsService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
    );

    const channel = AndroidNotificationChannel(
      channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> show(AppNotification notification) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelName,
        channelDescription: _channelDescription,
        icon: 'ic_notification',
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.message,
        visibility: NotificationVisibility.public,
      ),
    );

    await _plugin.show(
      id: notification.id.hashCode & 0x7fffffff,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: notification.id,
    );
  }
}
