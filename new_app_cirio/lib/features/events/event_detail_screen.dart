import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/event_model.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/favorite_button.dart';
import 'events_provider.dart';

/// Tela de detalhes de um evento.
///
/// Exibe categoria, título, data, horário, local e descrição completa.
/// O botão de favoritar na AppBar é sincronizado com o provider.
class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CirioAppBar(
        title: 'Detalhes do Evento',
        actions: [
          Consumer<EventsProvider>(
            builder: (_, provider, __) {
              final current = provider.events
                  .firstWhere((e) => e.id == event.id, orElse: () => event);
              return FavoriteButton(
                isFavorite: current.isFavorite,
                onTap: () => provider.toggleFavorite(current),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                event.category,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(event.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            _InfoRow(icon: Icons.calendar_today, label: 'Data', value: event.date),
            _InfoRow(icon: Icons.access_time, label: 'Horário', value: event.time),
            _InfoRow(icon: Icons.place, label: 'Local', value: event.location),
            const Divider(height: 32),
            Text('Sobre o evento', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(
              event.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
