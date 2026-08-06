import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/app_notification.dart';

class LocalNotificationsService {
  static const channelId = 'cirio_alerts';
  static const _channelName = 'Avisos do Círio';
  static const _channelDescription =
      'Notícias, alertas e informações importantes do Círio.';

  final FlutterLocalNotificationsPlugin _plugin;
  final _tapController = StreamController<AppNotification>.broadcast();

  // Guarda os dados completos de cada banner exibido, indexados pelo payload
  // (id da notificação). O toque do usuário só devolve o payload via plugin,
  // então precisamos resolver de volta para o AppNotification aqui — e fazer
  // isso a partir de um mapa preenchido em [show] evita a corrida de esperar
  // o NotificationsProvider persistir e atualizar sua lista em memória antes
  // que o usuário consiga tocar no banner.
  final _shown = <String, AppNotification>{};

  LocalNotificationsService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Emite a notificação quando o usuário toca num banner exibido localmente,
  /// com o app em primeiro ou segundo plano.
  Stream<AppNotification> get onTapped => _tapController.stream;

  Future<void> initialize() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final notification = _shown.remove(response.payload);
        if (notification != null) _tapController.add(notification);
      },
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
    _shown[notification.id] = notification;
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

  void dispose() => _tapController.close();
}
