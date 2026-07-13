/// Constantes globais do app.
///
/// Centraliza strings de categorias, chaves de persistência e coordenadas
/// para evitar magic numbers espalhados pelo código.
class AppConstants {
  // Prefixos usados na chave de persistência de favoritos ("tipo:id")
  static const String favoriteTypeEvent = 'event';
  static const String favoriteTypePlace = 'place';
  static const String favoriteTypeNews = 'news';

  // Categorias de pontos de interesse
  static const String categoryChurch = 'Igreja';
  static const String categoryHydration = 'Hidratação';
  static const String categoryFood = 'Alimentação';
  static const String categoryHealth = 'Saúde';
  static const String categoryRestroom = 'Banheiro';
  static const String categoryTourism = 'Turismo';

  // Centro aproximado de Belém (Praça Santuário de Nazaré)
  static const double belemLat = -1.4558;
  static const double belemLng = -48.5044;
}
