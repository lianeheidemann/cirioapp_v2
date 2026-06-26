import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cirio_app/core/constants/app_constants.dart';
import 'package:cirio_app/data/local/favorites_local_storage.dart';
import 'package:cirio_app/data/repositories/event_repository.dart';
import 'package:cirio_app/data/repositories/news_repository.dart';
import 'package:cirio_app/data/repositories/place_repository.dart';
import 'package:cirio_app/features/events/events_provider.dart';
import 'package:cirio_app/features/favorites/favorites_provider.dart';
import 'package:cirio_app/features/favorites/favorites_screen.dart';
import 'package:cirio_app/features/news/news_provider.dart';
import 'package:cirio_app/features/places/places_provider.dart';

import 'helpers/fake_services.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildApp(FavoritesProvider favoritesProvider) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favoritesProvider),
        ChangeNotifierProxyProvider<FavoritesProvider, EventsProvider>(
          create: (ctx) => EventsProvider(
            EventRepository(service: FakeEventService()),
            ctx.read<FavoritesProvider>(),
          ),
          update: (_, favs, prev) => prev!..updateFavorites(favs),
        ),
        ChangeNotifierProxyProvider<FavoritesProvider, PlacesProvider>(
          create: (ctx) => PlacesProvider(
            PlaceRepository(service: FakePlaceService()),
            ctx.read<FavoritesProvider>(),
          ),
          update: (_, favs, prev) => prev!..updateFavorites(favs),
        ),
        ChangeNotifierProxyProvider<FavoritesProvider, NewsProvider>(
          create: (ctx) => NewsProvider(
            NewsRepository(service: FakeNewsService()),
            ctx.read<FavoritesProvider>(),
          ),
          update: (_, favs, prev) => prev!..updateFavorites(favs),
        ),
      ],
      child: const MaterialApp(home: FavoritesScreen()),
    );
  }

  testWidgets('exibe favoritos salvos sem visitar outras telas', (tester) async {
    final storage = FavoritesLocalStorage();
    await storage.init();
    await storage.add('${AppConstants.favoriteTypeEvent}:e1');

    final favoritesProvider = FavoritesProvider(storage);
    await favoritesProvider.load();

    await tester.pumpWidget(buildApp(favoritesProvider));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Círio de Nazaré'), findsOneWidget);
    expect(find.text('Eventos'), findsOneWidget);
  });

  testWidgets('exibe estado vazio quando não há favoritos', (tester) async {
    final storage = FavoritesLocalStorage();
    await storage.init();

    final favoritesProvider = FavoritesProvider(storage);
    await favoritesProvider.load();

    await tester.pumpWidget(buildApp(favoritesProvider));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Você ainda não tem favoritos'),
      findsOneWidget,
    );
  });
}
