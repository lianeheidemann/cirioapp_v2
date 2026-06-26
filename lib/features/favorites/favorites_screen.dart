import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../events/events_provider.dart';
import '../places/places_provider.dart';
import '../news/news_provider.dart';
import '../events/event_detail_screen.dart';
import '../places/place_detail_screen.dart';
import '../news/news_detail_screen.dart';

/// Tela de favoritos com abas (Eventos / Locais / Notícias).
///
/// Carrega os dados de todas as seções ao abrir, garantindo que favoritos
/// salvos apareçam mesmo sem visitar as outras telas antes.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    await Future.wait([
      context.read<EventsProvider>().loadEvents(),
      context.read<PlacesProvider>().loadPlaces(),
      context.read<NewsProvider>().loadNews(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final eventsProvider = context.watch<EventsProvider>();
    final placesProvider = context.watch<PlacesProvider>();
    final newsProvider = context.watch<NewsProvider>();

    final isLoading = eventsProvider.isLoading ||
        placesProvider.isLoading ||
        newsProvider.isLoading;

    final favEvents = eventsProvider.getFavoriteEvents();
    final favPlaces = placesProvider.getFavoritePlaces();
    final favNews = newsProvider.getFavoriteNews();

    final hasAny =
        favEvents.isNotEmpty || favPlaces.isNotEmpty || favNews.isNotEmpty;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CirioAppBar(title: 'Favoritos'),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Eventos'),
                Tab(text: 'Locais'),
                Tab(text: 'Notícias'),
              ],
              labelColor: AppTheme.primaryBlue,
              indicatorColor: AppTheme.accentGold,
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !hasAny
                      ? const EmptyStateWidget(
                          icon: Icons.favorite_border,
                          message:
                              'Você ainda não tem favoritos.\nToque no ♡ em qualquer item para salvar.',
                        )
                      : TabBarView(
                          children: [
                            favEvents.isEmpty
                                ? const EmptyStateWidget(
                                    icon: Icons.event,
                                    message: 'Nenhum evento favorito.')
                                : ListView.builder(
                                    itemCount: favEvents.length,
                                    itemBuilder: (_, i) {
                                      final e = favEvents[i];
                                      return Card(
                                        child: ListTile(
                                          leading: const Icon(Icons.event,
                                              color: AppTheme.primaryBlue),
                                          title: Text(e.title),
                                          subtitle: Text('${e.date} — ${e.time}'),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.favorite,
                                                color: AppTheme.accentGold),
                                            onPressed: () => eventsProvider
                                                .toggleFavorite(e),
                                          ),
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EventDetailScreen(event: e),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            favPlaces.isEmpty
                                ? const EmptyStateWidget(
                                    icon: Icons.place,
                                    message: 'Nenhum local favorito.')
                                : ListView.builder(
                                    itemCount: favPlaces.length,
                                    itemBuilder: (_, i) {
                                      final p = favPlaces[i];
                                      return Card(
                                        child: ListTile(
                                          leading: const Icon(Icons.place,
                                              color: AppTheme.primaryBlue),
                                          title: Text(p.name),
                                          subtitle: Text(p.category),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.favorite,
                                                color: AppTheme.accentGold),
                                            onPressed: () => placesProvider
                                                .toggleFavorite(p),
                                          ),
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PlaceDetailScreen(place: p),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            favNews.isEmpty
                                ? const EmptyStateWidget(
                                    icon: Icons.newspaper,
                                    message: 'Nenhuma notícia favorita.')
                                : ListView.builder(
                                    itemCount: favNews.length,
                                    itemBuilder: (_, i) {
                                      final n = favNews[i];
                                      return Card(
                                        child: ListTile(
                                          leading: const Icon(Icons.newspaper,
                                              color: AppTheme.primaryBlue),
                                          title: Text(n.title),
                                          subtitle: Text(n.date),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.favorite,
                                                color: AppTheme.accentGold),
                                            onPressed: () =>
                                                newsProvider.toggleFavorite(n),
                                          ),
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  NewsDetailScreen(news: n),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
