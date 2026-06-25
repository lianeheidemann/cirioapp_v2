import '../models/place_model.dart';
import '../services/place_service.dart';

/// Repositório de pontos de interesse.
///
/// Abstrai a fonte de dados para o [PlacesProvider] e [MapProvider].
class PlaceRepository {
  final PlaceService _service = PlaceService();

  Future<List<PlaceModel>> getPlaces() => _service.fetchPlaces();
}
