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
  String? errorMessage;

  MapProvider(this._repository);

  /// Carrega todos os pontos de interesse do repositório.
  ///
  /// Evita recarregar se já houver dados ou uma busca em andamento, e
  /// trata falhas do repositório para não deixar a tela presa em
  /// carregamento indefinidamente.
  Future<void> loadPlaces() async {
    if (isLoading || places.isNotEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      places = await _repository.getPlaces();
    } catch (e) {
      errorMessage = 'Não foi possível carregar o mapa.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Define o local selecionado (exibe card) ou null (oculta card).
  void selectPlace(PlaceModel? place) {
    selectedPlace = place;
    notifyListeners();
  }
}
