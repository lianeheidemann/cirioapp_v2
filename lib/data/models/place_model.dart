/// Modelo que representa um ponto de interesse no mapa.
///
/// Inclui coordenadas ([latitude], [longitude]) para exibição no
/// OpenStreetMap, além de endereço e categoria para filtros.
class PlaceModel {
  final String id;
  final String name;
  final String category;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  bool isFavorite;

  PlaceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.isFavorite = false,
  });

  /// Retorna uma cópia com [isFavorite] opcionalmente alterado.
  PlaceModel copyWith({bool? isFavorite}) {
    return PlaceModel(
      id: id,
      name: name,
      category: category,
      address: address,
      description: description,
      latitude: latitude,
      longitude: longitude,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
