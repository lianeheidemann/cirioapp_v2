import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cirio_app/core/constants/app_constants.dart';
import 'package:cirio_app/data/local/favorites_local_storage.dart';
import 'package:cirio_app/data/repositories/event_repository.dart';
import 'package:cirio_app/features/events/events_provider.dart';
import 'package:cirio_app/features/favorites/favorites_provider.dart';

import 'helpers/fake_services.dart';

void main() {
  late FavoritesProvider favoritesProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = FavoritesLocalStorage();
    await storage.init();
    favoritesProvider = FavoritesProvider(storage);
    await favoritesProvider.load();
  });

  test('loadEvents carrega eventos do repositório', () async {
    final provider = EventsProvider(
      EventRepository(service: FakeEventService()),
      favoritesProvider,
    );

    await provider.loadEvents();

    expect(provider.events, hasLength(2));
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
  });

  test('getFavoriteEvents retorna favoritos após carregar dados', () async {
    await favoritesProvider.toggle(AppConstants.favoriteTypeEvent, 'e1');

    final provider = EventsProvider(
      EventRepository(service: FakeEventService()),
      favoritesProvider,
    );
    await provider.loadEvents();

    final favorites = provider.getFavoriteEvents();

    expect(favorites, hasLength(1));
    expect(favorites.first.id, 'e1');
    expect(favorites.first.isFavorite, isTrue);
  });

  test('getFavoriteEvents vazio antes de loadEvents', () async {
    await favoritesProvider.toggle(AppConstants.favoriteTypeEvent, 'e1');

    final provider = EventsProvider(
      EventRepository(service: FakeEventService()),
      favoritesProvider,
    );

    expect(provider.getFavoriteEvents(), isEmpty);
  });

  test('updateFavorites sincroniza isFavorite nos eventos', () async {
    final provider = EventsProvider(
      EventRepository(service: FakeEventService()),
      favoritesProvider,
    );
    await provider.loadEvents();

    await favoritesProvider.toggle(AppConstants.favoriteTypeEvent, 'e2');
    provider.updateFavorites(favoritesProvider);

    final event = provider.events.firstWhere((e) => e.id == 'e2');
    expect(event.isFavorite, isTrue);
  });

  test('loadEvents não recarrega se dados já existem', () async {
    final provider = EventsProvider(
      EventRepository(service: FakeEventService()),
      favoritesProvider,
    );
    await provider.loadEvents();
    final firstLoad = provider.events;

    await provider.loadEvents();

    expect(identical(firstLoad, provider.events), isTrue);
  });
}
