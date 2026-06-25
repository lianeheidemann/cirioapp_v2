import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/place_model.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/favorite_button.dart';
import 'places_provider.dart';

/// Tela de detalhes de um ponto de interesse.
///
/// Exibe categoria, nome, endereço, descrição e coordenadas geográficas.
class PlaceDetailScreen extends StatelessWidget {
  final PlaceModel place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CirioAppBar(
        title: 'Local',
        actions: [
          Consumer<PlacesProvider>(
            builder: (_, provider, __) {
              final current = provider.places
                  .firstWhere((p) => p.id == place.id, orElse: () => place);
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
            Chip(label: Text(place.category)),
            const SizedBox(height: 12),
            Text(place.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.place, color: AppTheme.primaryBlue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(place.address,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Descrição', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(
              place.description,
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.7),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gps_fixed,
                      color: AppTheme.primaryBlue, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Lat: ${place.latitude.toStringAsFixed(4)}, '
                    'Lng: ${place.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall,
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
