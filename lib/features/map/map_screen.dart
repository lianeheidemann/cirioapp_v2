import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/place_model.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'map_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  static const List<LatLng> _cirioRoute = [
    LatLng(-1.456108, -48.504719), // Catedral Metropolitana de Belém
    LatLng(-1.453650, -48.501180), // Acesso à avenida Presidente Vargas
    LatLng(-1.450300, -48.499150), // Avenida Presidente Vargas
    LatLng(-1.447360, -48.494850), // Praça da República
    LatLng(-1.448100, -48.491550), // Início da avenida Nazaré
    LatLng(-1.450200, -48.485000), // Avenida Nazaré
    LatLng(-1.452000, -48.479700), // Aproximação da Praça Santuário
    LatLng(-1.452624, -48.476270), // Basílica de Nazaré
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapProvider>().loadPlaces();
    });
  }

  void _centerCirioRoute() {
    _mapController.fitCamera(
      const CameraFit.coordinates(
        coordinates: _cirioRoute,
        padding: EdgeInsets.fromLTRB(40, 72, 40, 112),
        maxZoom: 15,
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CirioAppBar(
          title: tr(context, 'Mapa', 'Map'),
          subtitle: tr(context, 'Explore pontos úteis perto de você',
              'Explore useful places near you')),
      body: Consumer<MapProvider>(
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
                  // Traçado do percurso do Círio
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _cirioRoute,
                        strokeWidth: 5,
                        color: AppColors.gold,
                        borderStrokeWidth: 2,
                        borderColor: AppColors.navy,
                      ),
                    ],
                  ),
                  // Marcadores de saída e chegada do percurso
                  MarkerLayer(
                    markers: [
                      _routeEndpointMarker(
                        point: _cirioRoute.first,
                        icon: Icons.flag_outlined,
                        tooltip: tr(
                          context,
                          'Saída: Catedral Metropolitana de Belém',
                          'Start: Metropolitan Cathedral of Belém',
                        ),
                      ),
                      _routeEndpointMarker(
                        point: _cirioRoute.last,
                        icon: Icons.church_outlined,
                        tooltip: tr(
                          context,
                          'Chegada: Basílica de Nazaré',
                          'Finish: Basilica of Nazaré',
                        ),
                      ),
                    ],
                  ),
                  // Camada de marcadores
                  MarkerLayer(
                    markers: provider.places.map((place) {
                      return _buildMarker(context, place, provider);
                    }).toList(),
                  ),
                ],
              ),

              Positioned(
                top: 12,
                left: 12,
                child: _RouteCenterButton(
                  onPressed: _centerCirioRoute,
                ),
              ),

              // Card de informação ao selecionar marcador
              if (provider.selectedPlace != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
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

  Marker _routeEndpointMarker({
    required LatLng point,
    required IconData icon,
    required String tooltip,
  }) {
    return Marker(
      point: point,
      width: 48,
      height: 48,
      child: Tooltip(
        message: tooltip,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.navy,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: AppShadows.soft,
          ),
          child: Icon(icon, color: AppColors.gold, size: 22),
        ),
      ),
    );
  }

  Marker _buildMarker(
      BuildContext context, PlaceModel place, MapProvider provider) {
    final color = _markerColor(place.category);

    return Marker(
      point: LatLng(place.latitude, place.longitude),
      width: 52,
      height: 52,
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

class _RouteCenterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RouteCenterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface.withValues(alpha: .96),
        elevation: 0,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: AppColors.divider),
              boxShadow: AppShadows.soft,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(
                Icons.route_rounded,
                color: AppColors.gold,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                tr(context, 'Rota do Círio', 'Círio route'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.navy,
                    ),
              ),
            ]),
          ),
        ),
      );
}

// Card exibido ao selecionar um marcador
class _PlaceInfoCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onClose;

  const _PlaceInfoCard({required this.place, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                        ContentTranslations.place(context, place, 'name'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          ContentTranslations.place(context, place, 'category'),
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
                    ContentTranslations.place(context, place, 'address'),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              ContentTranslations.place(context, place, 'description'),
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
    _LegendItem(
        label: 'Igreja', color: AppTheme.primaryBlue, icon: Icons.church),
    _LegendItem(
        label: 'Hidratação',
        color: Color(0xFF1E88E5),
        icon: Icons.water_drop),
    _LegendItem(
        label: 'Alimentação',
        color: Color(0xFFE65100),
        icon: Icons.restaurant),
    _LegendItem(
        label: 'Saúde', color: Color(0xFFD32F2F), icon: Icons.local_hospital),
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
          color: AppColors.surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(18),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tr(context, 'Categorias', 'Categories'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.keyboard_arrow_up,
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
                            Text(
                                ContentTranslations.category(
                                    context, item.label),
                                style: const TextStyle(
                                    fontSize: 11, color: AppTheme.textDark)),
                          ],
                        ),
                      )),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.layers,
                      size: 18, color: AppTheme.primaryBlue),
                  const SizedBox(width: 4),
                  Text(
                    tr(context, 'Legenda', 'Legend'),
                    style: const TextStyle(
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
