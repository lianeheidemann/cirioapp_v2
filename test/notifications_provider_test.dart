import 'package:cirio_app/data/local/notifications_local_storage.dart';
import 'package:cirio_app/data/models/app_notification.dart';
import 'package:cirio_app/features/notifications/notifications_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
      'hasUnread e verdadeiro apos notificacao nao lida e falso apos markAllRead',
      () async {
    final storage = NotificationsLocalStorage();
    await storage.add(AppNotification(
      id: '1',
      title: 'Teste',
      body: 'Corpo',
      receivedAt: DateTime.now(),
    ));

    final provider = NotificationsProvider(storage, null);
    await provider.initialize();

    expect(provider.hasUnread, isTrue);

    await provider.markAllRead();

    expect(provider.hasUnread, isFalse);
    expect(provider.notifications.every((n) => n.isRead), isTrue);
  });

  test('markAllRead persiste o estado lido entre recarregamentos', () async {
    final storage = NotificationsLocalStorage();
    await storage.add(AppNotification(
      id: '1',
      title: 'Teste',
      body: 'Corpo',
      receivedAt: DateTime.now(),
    ));

    final provider = NotificationsProvider(storage, null);
    await provider.initialize();
    await provider.markAllRead();

    final reloaded = await storage.load();
    expect(reloaded.single.isRead, isTrue);
  });

  test('hasUnread e falso quando nao ha notificacoes', () async {
    final storage = NotificationsLocalStorage();
    final provider = NotificationsProvider(storage, null);
    await provider.initialize();

    expect(provider.hasUnread, isFalse);
  });
}
