import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cirio_app/data/local/favorites_local_storage.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadAll retorna conjunto vazio inicialmente', () async {
    final storage = FavoritesLocalStorage();
    await storage.init();

    expect(storage.loadAll(), isEmpty);
  });

  test('add persiste favorito', () async {
    final storage = FavoritesLocalStorage();
    await storage.init();

    await storage.add('event:e1');

    expect(storage.loadAll(), {'event:e1'});
  });

  test('remove exclui favorito', () async {
    final storage = FavoritesLocalStorage();
    await storage.init();
    await storage.add('event:e1');

    await storage.remove('event:e1');

    expect(storage.loadAll(), isEmpty);
  });

  test('saveAll substitui conjunto inteiro', () async {
    final storage = FavoritesLocalStorage();
    await storage.init();
    await storage.add('event:e1');

    await storage.saveAll({'place:p1', 'news:n1'});

    expect(storage.loadAll(), {'place:p1', 'news:n1'});
  });
}
