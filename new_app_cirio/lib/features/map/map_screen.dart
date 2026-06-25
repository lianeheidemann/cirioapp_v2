import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/place_model.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import 'map_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapProvider>().loadPlaces();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CirioAppBar(title: 'Mapa'),
      body: Consumer<MapProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(
                    AppConstants.belemLat,
                    AppConstants.belemLng,
                  ),
                  initialZoom: 14.5,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  // Camada de tiles OpenStreetMap
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.cirio_app',
                    maxZoom: 19,
                  ),
                  // Camada de marcadores
                  MarkerLayer(
                    markers: provider.places.map((place) {
                      return _buildMarker(context, place, provider);
                    }).toList(),
                  ),
                ],
              ),

              // Card de informação ao selecionar marcador
              if (provider.selectedPlace != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: _PlaceInfoCard(
                    place: provider.selectedPlace!,
                    onClose: () => provider.selectPlace(null),
                  ),
                ),

              // Legenda de categorias
              Positioned(
                top: 12,
                right: 12,
                child: _MapLegend(),
              ),
            ],
          );
        },
      ),
    );
  }

  Marker _buildMarker(
      BuildContext context, PlaceModel place, MapProvider provider) {
    final color = _markerColor(place.category);

    return Marker(
      point: LatLng(place.latitude, place.longitude),
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () {
          provider.selectPlace(place);
          // Centraliza o mapa no marcador selecionado
          _mapController.move(
            LatLng(place.latitude, place.longitude),
            15.0,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: provider.selectedPlace?.id == place.id
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.8),
              width: provider.selectedPlace?.id == place.id ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            _categoryIcon(place.category),
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Color _markerColor(String category) {
    switch (category) {
      case AppConstants.categoryChurch:
        return AppTheme.primaryBlue;
      case AppConstants.categoryHydration:
        return Colors.blue[600]!;
      case AppConstants.categoryFood:
        return Colors.orange[700]!;
      case AppConstants.categoryHealth:
        return Colors.red[600]!;
      case AppConstants.categoryRestroom:
        return Colors.teal[600]!;
      case AppConstants.categoryTourism:
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case AppConstants.categoryChurch:
        return Icons.church;
      case AppConstants.categoryHydration:
        return Icons.water_drop;
      case AppConstants.categoryFood:
        return Icons.restaurant;
      case AppConstants.categoryHealth:
        return Icons.local_hospital;
      case AppConstants.categoryRestroom:
        return Icons.wc;
      case AppConstants.categoryTourism:
        return Icons.star;
      default:
        return Icons.place;
    }
  }
}

// Card exibido ao selecionar um marcador
class _PlaceInfoCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onClose;

  const _PlaceInfoCard({required this.place, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          place.category,
                          style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClose,
                  color: Colors.grey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.place_outlined,
                    size: 14, color: AppTheme.textLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    place.address,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              place.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Legenda das categorias no canto superior direito
class _MapLegend extends StatefulWidget {
  @override
  State<_MapLegend> createState() => _MapLegendState();
}

class _MapLegendState extends State<_MapLegend> {
  bool _expanded = false;

  final _items = const [
    _LegendItem(label: 'Igreja', color: AppTheme.primaryBlue, icon: Icons.church),
    _LegendItem(label: 'Hidratação', color: Color(0xFF1E88E5), icon: Icons.water_drop),
    _LegendItem(label: 'Alimentação', color: Color(0xFFE65100), icon: Icons.restaurant),
    _LegendItem(label: 'Saúde', color: Color(0xFFD32F2F), icon: Icons.local_hospital),
    _LegendItem(label: 'Banheiro', color: Color(0xFF00796B), icon: Icons.wc),
    _LegendItem(label: 'Turismo', color: Color(0xFF7B1FA2), icon: Icons.star),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: _expanded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Categorias',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.keyboard_arrow_up,
                          size: 16, color: AppTheme.textLight),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ..._items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(item.icon,
                                  color: Colors.white, size: 11),
                            ),
                            const SizedBox(width: 6),
                            Text(item.label,
                                style: const TextStyle(
                                    fontSize: 11, color: AppTheme.textDark)),
                          ],
                        ),
                      )),
                ],
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.layers,
                      size: 18, color: AppTheme.primaryBlue),
                  SizedBox(width: 4),
                  Text(
                    'Legenda',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }
}

class _LegendItem {
  final String label;
  final Color color;
  final IconData icon;

  const _LegendItem(
      {required this.label, required this.color, required this.icon});
}
