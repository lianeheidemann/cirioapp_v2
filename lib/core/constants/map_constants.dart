import 'package:latlong2/latlong.dart';

/// Coordenadas das rotas oficiais do Círio, usadas para traçar as
/// procissões no mapa.
class MapConstants {
  static const LatLng basilica = LatLng(-1.452624, -48.476270);
  static const LatLng catedral = LatLng(-1.456108, -48.504719);

  // Rota oficial do Círio (Catedral -> Basílica)
  static const List<LatLng> rotaCirio = [
    catedral,
    LatLng(-1.455800, -48.495000),
    LatLng(-1.455200, -48.488500),
    LatLng(-1.454200, -48.482000),
    basilica,
  ];

  // Rota da Trasladação (Basílica -> Catedral)
  static const List<LatLng> rotaTranslacao = [
    basilica,
    LatLng(-1.454200, -48.482000),
    LatLng(-1.455200, -48.488500),
    LatLng(-1.455800, -48.495000),
    catedral,
  ];
}
