import 'package:flutter/material.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/place_repository.dart';
import '../../data/services/location_service.dart';

enum LocationRequestResult {
  success,
  permissionRequired,
  permissionDenied,
  permissionDeniedForever,
  serviceDisabled,
  error,
}

/// Provider da tela de mapa.
///
/// Carrega pontos de interesse do [PlaceRepository] e gerencia o
/// local selecionado para exibir o card inferior de informações.
class MapProvider extends ChangeNotifier {
  final PlaceRepository _repository;
  final LocationService _locationService;
  List<PlaceModel> places = [];
  PlaceModel? selectedPlace;
  UserLocation? currentLocation;
  bool isLoading = false;
  bool isLocating = false;
  String? errorMessage;

  MapProvider(
    this._repository, {
    LocationService? locationService,
  }) : _locationService = locationService ?? GeolocatorLocationService();

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

  Future<LocationRequestResult> locateUser({
    bool requestPermission = false,
  }) async {
    if (isLocating) return LocationRequestResult.error;

    isLocating = true;
    notifyListeners();

    try {
      if (!await _locationService.isServiceEnabled()) {
        return LocationRequestResult.serviceDisabled;
      }

      var permission = await _locationService.checkPermission();
      if (permission == AppLocationPermission.denied && !requestPermission) {
        return LocationRequestResult.permissionRequired;
      }
      if (permission == AppLocationPermission.denied) {
        permission = await _locationService.requestPermission();
      }
      if (permission == AppLocationPermission.deniedForever) {
        return LocationRequestResult.permissionDeniedForever;
      }
      if (permission != AppLocationPermission.granted) {
        return LocationRequestResult.permissionDenied;
      }

      currentLocation = await _locationService.getCurrentLocation();
      return LocationRequestResult.success;
    } catch (_) {
      return LocationRequestResult.error;
    } finally {
      isLocating = false;
      notifyListeners();
    }
  }

  Future<bool> openAppSettings() => _locationService.openAppSettings();

  Future<bool> openLocationSettings() =>
      _locationService.openLocationSettings();
}
