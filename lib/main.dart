import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/localization/app_language.dart';
import 'data/repositories/event_repository.dart';
import 'data/repositories/place_repository.dart';
import 'data/repositories/news_repository.dart';
import 'data/local/favorites_local_storage.dart';
import 'features/events/events_provider.dart';
import 'features/places/places_provider.dart';
import 'features/map/map_provider.dart';
import 'features/news/news_provider.dart';
import 'features/favorites/favorites_provider.dart';
import 'features/ai_assistant/ai_assistant_provider.dart';

/// Ponto de entrada do app.
///
/// Inicializa o armazenamento local de favoritos e configura a árvore de
/// [MultiProvider] com todos os providers da aplicação. Os providers de
/// eventos, locais e notícias usam [ChangeNotifierProxyProvider] para
/// reagir automaticamente a mudanças nos favoritos.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favoritesStorage = FavoritesLocalStorage();
  await favoritesStorage.init();

  final favoritesProvider = FavoritesProvider(favoritesStorage);
  await favoritesProvider.load();

  await dotenv.load(fileName: ".env");

  final languageProvider = await LanguageProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        // Provider raiz de favoritos — carregado do SharedPreferences
        ChangeNotifierProvider.value(value: favoritesProvider),
        // Providers filhos que escutam o FavoritesProvider
        ChangeNotifierProxyProvider<FavoritesProvider, EventsProvider>(
          create: (ctx) => EventsProvider(
            EventRepository(),
            ctx.read<FavoritesProvider>(),
          ),
          update: (_, favs, prev) => prev!..updateFavorites(favs),
        ),
        ChangeNotifierProxyProvider<FavoritesProvider, PlacesProvider>(
          create: (ctx) => PlacesProvider(
            PlaceRepository(),
            ctx.read<FavoritesProvider>(),
          ),
          update: (_, favs, prev) => prev!..updateFavorites(favs),
        ),
        ChangeNotifierProxyProvider<FavoritesProvider, NewsProvider>(
          create: (ctx) => NewsProvider(
            NewsRepository(),
            ctx.read<FavoritesProvider>(),
          ),
          update: (_, favs, prev) => prev!..updateFavorites(favs),
        ),
        ChangeNotifierProvider(create: (_) => MapProvider(PlaceRepository())),
        // Assistente IA — não depende de favoritos, apenas lê eventos/locais.
        ChangeNotifierProvider(create: (_) => AiAssistantProvider()),
      ],
      child: const CirioApp(),
    ),
  );
}
