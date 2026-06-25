import 'package:flutter/material.dart';
import '../../data/local/favorites_local_storage.dart';

/// Provider raiz de favoritos.
///
/// Mantém um Set de strings "tipo:id" sincronizado com o
/// [FavoritesLocalStorage]. Outros providers escutam suas mudanças
/// via [ChangeNotifierProxyProvider].
class FavoritesProvider extends ChangeNotifier {
  final FavoritesLocalStorage _storage;
  Set<String> _favorites = {};

  FavoritesProvider(this._storage);

  Set<String> get favorites => _favorites;

  /// Carrega favoritos salvos do disco.
  Future<void> load() async {
    _favorites = _storage.loadAll();
    notifyListeners();
  }

  /// Verifica se um item (tipo + id) está nos favoritos.
  bool isFavorite(String type, String id) {
    return _favorites.contains('$type:$id');
  }

  /// Alterna o estado de favorito e persiste.
  Future<void> toggle(String type, String id) async {
    final key = '$type:$id';
    if (_favorites.contains(key)) {
      _favorites.remove(key);
      await _storage.remove(key);
    } else {
      _favorites.add(key);
      await _storage.add(key);
    }
    notifyListeners();
  }

  /// Retorna os IDs favoritados de um determinado tipo.
  List<String> getIdsByType(String type) {
    return _favorites
        .where((k) => k.startsWith('$type:'))
        .map((k) => k.split(':')[1])
        .toList();
  }
}
