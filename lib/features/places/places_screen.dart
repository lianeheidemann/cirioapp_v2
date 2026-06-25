import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'places_provider.dart';
import 'place_detail_screen.dart';

/// Tela de listagem de pontos de interesse.
///
/// Exibe filtro horizontal por categoria e lista de cards.
/// Cada card mostra nome, categoria com ícone colorido e endereço.
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesProvider>().loadPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CirioAppBar(title: 'Pontos de Interesse'),
      body: Consumer<PlacesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: provider.categories.map((cat) {
                    final selected = provider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: selected,
                        onSelected: (_) => provider.setCategory(cat),
                        selectedColor: AppTheme.primaryBlue,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: provider.filteredPlaces.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.place_outlined,
                        message: 'Nenhum local encontrado.')
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: provider.filteredPlaces.length,
                        itemBuilder: (_, i) {
                          final place = provider.filteredPlaces[i];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _categoryColor(place.category)
                                    .withValues(alpha: 0.15),
                                child: Icon(
                                  _categoryIcon(place.category),
                                  color: _categoryColor(place.category),
                                  size: 20,
                                ),
                              ),
                              title: Text(place.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text(place.category),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text(place.address,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              trailing: Icon(
                                place.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: place.isFavorite
                                    ? AppTheme.accentGold
                                    : Colors.grey[400],
                                size: 20,
                              ),
                              isThreeLine: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PlaceDetailScreen(place: place),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Igreja':
        return Icons.church;
      case 'Hidratação':
        return Icons.water_drop;
      case 'Alimentação':
        return Icons.restaurant;
      case 'Saúde':
        return Icons.local_hospital;
      case 'Banheiro':
        return Icons.wc;
      default:
        return Icons.star;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Igreja':
        return AppTheme.primaryBlue;
      case 'Hidratação':
        return Colors.blue;
      case 'Alimentação':
        return Colors.orange;
      case 'Saúde':
        return Colors.red;
      case 'Banheiro':
        return Colors.teal;
      default:
        return Colors.purple;
    }
  }
}
