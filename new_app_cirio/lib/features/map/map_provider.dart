import 'package:flutter/material.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/place_repository.dart';

/// Provider da tela de mapa.
///
/// Carrega pontos de interesse do [PlaceRepository] e gerencia o
/// local selecionado para exibir o card inferior de informações.
class MapProvider extends ChangeNotifier {
  final PlaceRepository _repository;
  List<PlaceModel> places = [];
  PlaceModel? selectedPlace;
  bool isLoading = false;

  MapProvider(this._repository);

  /// Carrega todos os pontos de interesse do repositório.
  Future<void> loadPlaces() async {
    isLoading = true;
    notifyListeners();
    places = await _repository.getPlaces();
    isLoading = false;
    notifyListeners();
  }

  /// Define o local selecionado (exibe card) ou null (oculta card).
  void selectPlace(PlaceModel? place) {
    selectedPlace = place;
    notifyListeners();
  }
}
