import 'package:cirio_app/data/local/notifications_local_storage.dart';
import 'package:cirio_app/data/models/app_notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('persiste notificacoes em ordem da mais recente', () async {
    final storage = NotificationsLocalStorage();
    final first = AppNotification(
      id: 'first',
      title: 'Primeiro aviso',
      body: 'Mensagem',
      receivedAt: DateTime(2026, 10, 10, 8),
    );
    final second = AppNotification(
      id: 'second',
      title: 'Segundo aviso',
      body: 'Mensagem',
      receivedAt: DateTime(2026, 10, 10, 9),
    );

    await storage.add(first);
    await storage.add(second);

    final restored = await NotificationsLocalStorage().load();
    expect(restored.map((item) => item.id), ['second', 'first']);
  });

  test('substitui uma notificacao com o mesmo id', () async {
    final storage = NotificationsLocalStorage();
    final receivedAt = DateTime(2026, 10, 10, 8);

    await storage.add(AppNotification(
      id: 'same-id',
      title: 'Original',
      body: '',
      receivedAt: receivedAt,
    ));
    await storage.add(AppNotification(
      id: 'same-id',
      title: 'Atualizada',
      body: '',
      receivedAt: receivedAt,
    ));

    final restored = await storage.load();
    expect(restored, hasLength(1));
    expect(restored.single.title, 'Atualizada');
  });

  test('limpa o historico local', () async {
    final storage = NotificationsLocalStorage();
    await storage.add(AppNotification(
      id: 'notice',
      title: 'Aviso',
      body: '',
      receivedAt: DateTime(2026),
    ));

    await storage.clear();

    expect(await storage.load(), isEmpty);
  });
}
