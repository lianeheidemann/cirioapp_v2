import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/event_model.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/favorite_button.dart';
import 'events_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CirioAppBar(
            title: tr(context, 'Detalhes do evento', 'Event details'),
            actions: [
              Consumer<EventsProvider>(builder: (_, p, __) {
                final current = p.events.firstWhere(
                    (item) => item.id == event.id,
                    orElse: () => event);
                return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FavoriteButton(
                        isFavorite: current.isFavorite,
                        onTap: () => p.toggleFavorite(current)));
              })
            ]),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.navy, AppColors.secondaryBlue]),
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(999)),
                            child: Text(
                                ContentTranslations.event(
                                    context, event, 'category'),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: AppColors.gold))),
                        const SizedBox(height: 16),
                        Text(ContentTranslations.event(context, event, 'title'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white)),
                      ])),
              const SizedBox(height: 16),
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.divider)),
                  child: Column(children: [
                    _Info(
                        Icons.calendar_today_outlined,
                        tr(context, 'Data', 'Date'),
                        ContentTranslations.event(context, event, 'date')),
                    const Divider(height: 25),
                    _Info(Icons.schedule_rounded,
                        tr(context, 'Horário', 'Time'), event.time),
                    const Divider(height: 25),
                    _Info(
                        Icons.location_on_outlined,
                        tr(context, 'Local', 'Place'),
                        ContentTranslations.event(context, event, 'location')),
                  ])),
              const SizedBox(height: 24),
              Text(tr(context, 'Sobre o evento', 'About the event'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(ContentTranslations.event(context, event, 'description'),
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 32),
            ])),
      );
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Info(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.secondaryBlue, size: 21)),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleSmall)
        ])),
      ]);
}
