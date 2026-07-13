import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../firebase_options.dart';
import '../local/notifications_local_storage.dart';
import '../models/app_notification.dart';
import 'local_notifications_service.dart';

enum NotificationsPermission { authorized, provisional, denied, notDetermined }

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await NotificationsLocalStorage().add(notificationFromMessage(message));
  } catch (_) {
    // The operating system can still display the push notification if the
    // local history cannot be updated from this background isolate.
  }
}

AppNotification notificationFromMessage(RemoteMessage message) {
  final notification = message.notification;
  final sentAt = message.sentTime ?? DateTime.now();
  return AppNotification(
    id: message.messageId ??
        '${sentAt.microsecondsSinceEpoch}-${message.data.hashCode}',
    title: notification?.title ?? message.data['title'] ?? 'CírioApp',
    body: notification?.body ?? message.data['body'] ?? '',
    receivedAt: sentAt,
    data: message.data.map(
      (key, value) => MapEntry(key, value.toString()),
    ),
  );
}

class FirebaseNotificationsService {
  final FirebaseMessaging _messaging;
  final LocalNotificationsService? _localNotifications;

  FirebaseNotificationsService({
    FirebaseMessaging? messaging,
    LocalNotificationsService? localNotifications,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications = localNotifications;

  Stream<AppNotification> get onForegroundMessage =>
      FirebaseMessaging.onMessage.asyncMap((message) async {
        final notification = notificationFromMessage(message);
        try {
          await _localNotifications?.show(notification);
        } catch (_) {
          // The in-app history must still be updated if Android cannot display
          // the system banner (for example, when permission was revoked).
        }
        return notification;
      });

  Stream<AppNotification> get onNotificationOpened =>
      FirebaseMessaging.onMessageOpenedApp.map(notificationFromMessage);

  Future<AppNotification?> getInitialNotification() async {
    final message = await _messaging.getInitialMessage();
    return message == null ? null : notificationFromMessage(message);
  }

  Future<NotificationsPermission> permission() async => _mapPermission(
      (await _messaging.getNotificationSettings()).authorizationStatus);

  Future<NotificationsPermission> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final permission = _mapPermission(settings.authorizationStatus);
    if (permission == NotificationsPermission.authorized ||
        permission == NotificationsPermission.provisional) {
      try {
        await _messaging.subscribeToTopic('cirio_updates');
      } catch (_) {
        // A token may not be ready yet. Direct Firebase campaigns still work.
      }
    }
    return permission;
  }

  NotificationsPermission _mapPermission(AuthorizationStatus status) {
    return switch (status) {
      AuthorizationStatus.authorized => NotificationsPermission.authorized,
      AuthorizationStatus.provisional => NotificationsPermission.provisional,
      AuthorizationStatus.denied => NotificationsPermission.denied,
      AuthorizationStatus.notDetermined =>
        NotificationsPermission.notDetermined,
    };
  }
}
