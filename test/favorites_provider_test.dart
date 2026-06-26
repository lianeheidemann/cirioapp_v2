import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cirio_app/core/constants/app_constants.dart';
import 'package:cirio_app/data/local/favorites_local_storage.dart';
import 'package:cirio_app/features/favorites/favorites_provider.dart';

void main() {
  late FavoritesLocalStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = FavoritesLocalStorage();
    await storage.init();
  });

  test('load restaura favoritos salvos', () async {
    await storage.add('event:e1');
    await storage.add('place:p1');

    final provider = FavoritesProvider(storage);
    await provider.load();

    expect(provider.isFavorite(AppConstants.favoriteTypeEvent, 'e1'), isTrue);
    expect(provider.isFavorite(AppConstants.favoriteTypePlace, 'p1'), isTrue);
    expect(provider.favorites, {'event:e1', 'place:p1'});
  });

  test('toggle adiciona e remove favorito', () async {
    final provider = FavoritesProvider(storage);
    await provider.load();

    await provider.toggle(AppConstants.favoriteTypeEvent, 'e1');
    expect(provider.isFavorite(AppConstants.favoriteTypeEvent, 'e1'), isTrue);

    await provider.toggle(AppConstants.favoriteTypeEvent, 'e1');
    expect(provider.isFavorite(AppConstants.favoriteTypeEvent, 'e1'), isFalse);
  });

  test('toggle persiste no armazenamento local', () async {
    final provider = FavoritesProvider(storage);
    await provider.load();

    await provider.toggle(AppConstants.favoriteTypeNews, 'n1');

    expect(storage.loadAll(), {'news:n1'});
  });

  test('getIdsByType retorna ids corretos', () async {
    final provider = FavoritesProvider(storage);
    await provider.load();
    await provider.toggle(AppConstants.favoriteTypeEvent, 'e1');
    await provider.toggle(AppConstants.favoriteTypeEvent, 'e2');
    await provider.toggle(AppConstants.favoriteTypePlace, 'p1');

    expect(
      provider.getIdsByType(AppConstants.favoriteTypeEvent),
      containsAll(['e1', 'e2']),
    );
    expect(
      provider.getIdsByType(AppConstants.favoriteTypePlace),
      ['p1'],
    );
    expect(provider.getIdsByType(AppConstants.favoriteTypeNews), isEmpty);
  });

  test('favorites expõe conjunto imutável', () async {
    final provider = FavoritesProvider(storage);
    await provider.load();

    expect(
      () => provider.favorites.add('event:e1'),
      throwsUnsupportedError,
    );
  });
}
