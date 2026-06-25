import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../core/constants/app_constants.dart';
import '../favorites/favorites_provider.dart';

/// Provider da tela de eventos.
///
/// Carrega eventos do [EventRepository] e sincroniza o estado de
/// favorito com o [FavoritesProvider]. Expõe [isLoading], [errorMessage]
/// e [events] para o [EventsScreen] consumir via [Consumer].
class EventsProvider extends ChangeNotifier {
  final EventRepository _repository;
  FavoritesProvider _favoritesProvider;

  List<EventModel> _events = [];
  bool isLoading = false;
  String? errorMessage;

  EventsProvider(this._repository, this._favoritesProvider);

  List<EventModel> get events => _events;

  /// Chamado pelo [ChangeNotifierProxyProvider] quando favoritos mudam.
  void updateFavorites(FavoritesProvider favs) {
    _favoritesProvider = favs;
    _syncFavorites();
    notifyListeners();
  }

  /// Busca eventos do repositório e atualiza favoritos.
  Future<void> loadEvents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _events = await _repository.getEvents();
      _syncFavorites();
    } catch (e) {
      errorMessage = 'Não foi possível carregar os eventos.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Sincroniza campo [EventModel.isFavorite] com o provider de favoritos.
  void _syncFavorites() {
    for (var i = 0; i < _events.length; i++) {
      _events[i] = _events[i].copyWith(
        isFavorite: _favoritesProvider.isFavorite(
          AppConstants.favoriteTypeEvent,
          _events[i].id,
        ),
      );
    }
  }

  /// Alterna favorito de um evento.
  Future<void> toggleFavorite(EventModel event) async {
    await _favoritesProvider.toggle(AppConstants.favoriteTypeEvent, event.id);
  }

  /// Retorna apenas os eventos favoritados.
  List<EventModel> getFavoriteEvents() {
    final ids = _favoritesProvider.getIdsByType(AppConstants.favoriteTypeEvent);
    return _events.where((e) => ids.contains(e.id)).toList();
  }
}
