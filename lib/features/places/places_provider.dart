import 'package:flutter/material.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/place_repository.dart';
import '../../core/constants/app_constants.dart';
import '../favorites/favorites_provider.dart';

/// Provider da tela de pontos de interesse.
///
/// Gerencia carregamento, filtro por categoria e sincronização de
/// favoritos. Expõe [filteredPlaces] e [categories] para a UI.
class PlacesProvider extends ChangeNotifier {
  final PlaceRepository _repository;
  FavoritesProvider _favoritesProvider;

  List<PlaceModel> _places = [];
  String _selectedCategory = 'Todos';
  bool isLoading = false;

  PlacesProvider(this._repository, this._favoritesProvider);

  List<PlaceModel> get places => _places;
  String get selectedCategory => _selectedCategory;

  /// Locais filtrados pela categoria selecionada.
  List<PlaceModel> get filteredPlaces {
    if (_selectedCategory == 'Todos') return _places;
    return _places.where((p) => p.category == _selectedCategory).toList();
  }

  /// Lista de categorias disponíveis (extraída dos dados).
  List<String> get categories {
    final cats = _places.map((p) => p.category).toSet().toList()..sort();
    return ['Todos', ...cats];
  }

  void updateFavorites(FavoritesProvider favs) {
    _favoritesProvider = favs;
    _syncFavorites();
    notifyListeners();
  }

  /// Altera o filtro de categoria ativo.
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Carrega locais do repositório.
  Future<void> loadPlaces() async {
    if (isLoading || _places.isNotEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      _places = await _repository.getPlaces();
      _syncFavorites();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _syncFavorites() {
    for (var i = 0; i < _places.length; i++) {
      _places[i] = _places[i].copyWith(
        isFavorite: _favoritesProvider.isFavorite(
          AppConstants.favoriteTypePlace,
          _places[i].id,
        ),
      );
    }
  }

  Future<void> toggleFavorite(PlaceModel place) async {
    await _favoritesProvider.toggle(AppConstants.favoriteTypePlace, place.id);
  }

  List<PlaceModel> getFavoritePlaces() {
    final ids = _favoritesProvider.getIdsByType(AppConstants.favoriteTypePlace);
    return _places.where((p) => ids.contains(p.id)).toList();
  }
}
