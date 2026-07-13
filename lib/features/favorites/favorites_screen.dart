import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_loading.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../events/event_detail_screen.dart';
import '../events/events_provider.dart';
import '../news/news_detail_screen.dart';
import '../news/news_provider.dart';
import '../places/place_detail_screen.dart';
import '../places/places_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => Future.wait([
          context.read<EventsProvider>().loadEvents(),
          context.read<PlacesProvider>().loadPlaces(),
          context.read<NewsProvider>().loadNews()
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventsProvider>();
    final places = context.watch<PlacesProvider>();
    final news = context.watch<NewsProvider>();
    final loading = events.isLoading || places.isLoading || news.isLoading;
    final favEvents = events.getFavoriteEvents();
    final favPlaces = places.getFavoritePlaces();
    final favNews = news.getFavoriteNews();
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: CirioAppBar(
              title: tr(context, 'Favoritos', 'Favorites'),
              subtitle: tr(context, 'Seu Círio, guardado em um só lugar',
                  'Your Círio, kept in one place')),
          body: Column(children: [
            Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TabBar(
                  indicatorColor: AppColors.gold,
                  indicatorWeight: 3,
                  labelColor: AppColors.navy,
                  unselectedLabelColor: AppColors.muted,
                  tabs: [
                    Tab(text: tr(context, 'Eventos', 'Events')),
                    Tab(text: tr(context, 'Locais', 'Places')),
                    Tab(text: tr(context, 'Notícias', 'News'))
                  ],
                )),
            Expanded(
                child: loading
                    ? const AppLoadingList()
                    : TabBarView(children: [
                        _FavoriteList(
                          emptyIcon: Icons.event_outlined,
                          emptyText: tr(
                              context,
                              'Você ainda não tem favoritos. Nenhum evento foi salvo.',
                              'You do not have favorites yet. No event has been saved.'),
                          count: favEvents.length,
                          builder: (context, i) {
                            final e = favEvents[i];
                            return _FavoriteTile(
                                icon: Icons.calendar_month_outlined,
                                eyebrow: [
                                  ContentTranslations.event(context, e, 'date'),
                                  e.time
                                ].join(' • '),
                                title: ContentTranslations.event(
                                    context, e, 'title'),
                                onRemove: () => events.toggleFavorite(e),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            EventDetailScreen(event: e))));
                          },
                        ),
                        _FavoriteList(
                          emptyIcon: Icons.location_on_outlined,
                          emptyText: tr(
                              context,
                              'Você ainda não tem locais favoritos.',
                              'You do not have favorite places yet.'),
                          count: favPlaces.length,
                          builder: (context, i) {
                            final p = favPlaces[i];
                            return _FavoriteTile(
                                icon: Icons.location_on_outlined,
                                eyebrow: ContentTranslations.place(
                                    context, p, 'category'),
                                title: ContentTranslations.place(
                                    context, p, 'name'),
                                onRemove: () => places.toggleFavorite(p),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            PlaceDetailScreen(place: p))));
                          },
                        ),
                        _FavoriteList(
                          emptyIcon: Icons.newspaper_outlined,
                          emptyText: tr(
                              context,
                              'Você ainda não tem notícias favoritas.',
                              'You do not have favorite news yet.'),
                          count: favNews.length,
                          builder: (context, i) {
                            final n = favNews[i];
                            return _FavoriteTile(
                                icon: Icons.newspaper_outlined,
                                eyebrow: ContentTranslations.news(
                                    context, n, 'date'),
                                title: ContentTranslations.news(
                                    context, n, 'title'),
                                onRemove: () => news.toggleFavorite(n),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            NewsDetailScreen(news: n))));
                          },
                        ),
                      ])),
          ]),
        ));
  }
}

class _FavoriteList extends StatelessWidget {
  final IconData emptyIcon;
  final String emptyText;
  final int count;
  final NullableIndexedWidgetBuilder builder;
  const _FavoriteList(
      {required this.emptyIcon,
      required this.emptyText,
      required this.count,
      required this.builder});
  @override
  Widget build(BuildContext context) => count == 0
      ? EmptyStateWidget(
          icon: emptyIcon,
          title: tr(context, 'Comece sua coleção', 'Start your collection'),
          message: emptyText)
      : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: count,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: builder);
}

class _FavoriteTile extends StatelessWidget {
  final IconData icon;
  final String eyebrow;
  final String title;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  const _FavoriteTile(
      {required this.icon,
      required this.eyebrow,
      required this.title,
      required this.onRemove,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.divider)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          color: AppColors.softBlue,
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(icon, color: AppColors.secondaryBlue)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(eyebrow,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.secondaryBlue)),
                        const SizedBox(height: 4),
                        Text(title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium)
                      ])),
                  IconButton(
                      onPressed: onRemove,
                      tooltip: tr(context, 'Remover dos favoritos',
                          'Remove from favorites'),
                      icon: const Icon(Icons.favorite_rounded,
                          color: AppColors.gold)),
                ]))),
      );
}
