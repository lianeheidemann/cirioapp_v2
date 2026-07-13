import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_loading.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'event_detail_screen.dart';
import 'events_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<EventsProvider>().loadEvents());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CirioAppBar(
            title: tr(context, 'Programação', 'Schedule'),
            subtitle: tr(context, 'Eventos do Círio de Nazaré',
                'Círio of Nazaré events')),
        body: Consumer<EventsProvider>(builder: (context, p, _) {
          if (p.isLoading) {
            return const AppLoadingList();
          }
          if (p.errorMessage != null) {
            return EmptyStateWidget(
                icon: Icons.error_outline,
                title:
                    tr(context, 'Não foi possível carregar', 'Unable to load'),
                message: p.errorMessage!,
                onRetry: p.loadEvents);
          }
          if (p.events.isEmpty) {
            return EmptyStateWidget(
                icon: Icons.event_busy_outlined,
                message: tr(
                    context, 'Nenhum evento encontrado.', 'No events found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: p.events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final e = p.events[i];
              final featured = i == 1;
              return Material(
                color: featured ? AppColors.navy : AppColors.surface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                        color: featured ? AppColors.navy : AppColors.divider)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailScreen(event: e))),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 58,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                    color: featured
                                        ? Colors.white12
                                        : AppColors.softBlue,
                                    borderRadius: BorderRadius.circular(18)),
                                child: Column(children: [
                                  Icon(Icons.calendar_today_outlined,
                                      color: featured
                                          ? AppColors.gold
                                          : AppColors.secondaryBlue,
                                      size: 19),
                                  const SizedBox(height: 8),
                                  Text(e.time,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: featured
                                                  ? Colors.white
                                                  : AppColors.navy)),
                                ])),
                            const SizedBox(width: 16),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                      ContentTranslations.event(
                                              context, e, 'category')
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: featured
                                                  ? AppColors.gold
                                                  : AppColors.secondaryBlue,
                                              letterSpacing: .7)),
                                  const SizedBox(height: 6),
                                  Text(
                                      ContentTranslations.event(
                                          context, e, 'title'),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: featured
                                                  ? Colors.white
                                                  : AppColors.ink)),
                                  const SizedBox(height: 8),
                                  _Meta(
                                      Icons.schedule_rounded,
                                      ContentTranslations.event(
                                          context, e, 'date'),
                                      featured),
                                  const SizedBox(height: 4),
                                  _Meta(
                                      Icons.location_on_outlined,
                                      ContentTranslations.event(
                                          context, e, 'location'),
                                      featured),
                                ])),
                            IconButton(
                                onPressed: () => p.toggleFavorite(e),
                                tooltip: e.isFavorite
                                    ? tr(context, 'Remover dos favoritos',
                                        'Remove from favorites')
                                    : tr(context, 'Adicionar aos favoritos',
                                        'Add to favorites'),
                                icon: Icon(
                                    e.isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: e.isFavorite
                                        ? AppColors.gold
                                        : (featured
                                            ? Colors.white70
                                            : AppColors.muted))),
                          ]),
                    )),
              );
            },
          );
        }),
      );
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool light;
  const _Meta(this.icon, this.text, this.light);
  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 15, color: light ? Colors.white70 : AppColors.muted),
        const SizedBox(width: 5),
        Expanded(
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: light ? Colors.white70 : AppColors.muted)))
      ]);
}
