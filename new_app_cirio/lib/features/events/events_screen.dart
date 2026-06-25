import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'events_provider.dart';
import 'event_detail_screen.dart';

/// Tela de listagem de eventos do Círio.
///
/// Consome [EventsProvider] via [Consumer]. Exibe loading, erro, vazio
/// ou lista de cards. Cada card mostra título, data, horário, local
/// e indicador de favorito.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CirioAppBar(title: 'Eventos'),
      body: Consumer<EventsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              message: provider.errorMessage!,
            );
          }
          if (provider.events.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.event_busy,
              message: 'Nenhum evento encontrado.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.events.length,
            itemBuilder: (ctx, i) {
              final event = provider.events[i];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.event, color: AppTheme.primaryBlue),
                  ),
                  title: Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 13, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Text('${event.date} — ${event.time}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.place,
                              size: 13, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(
                    event.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: event.isFavorite
                        ? AppTheme.accentGold
                        : Colors.grey[400],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: event),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
