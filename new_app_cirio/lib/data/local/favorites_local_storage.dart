import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local de favoritos via [SharedPreferences].
///
/// Armazena um Set de strings no formato "tipo:id".
/// Exemplo: "event:e1", "place:p3", "news:n2".
/// Permite que qualquer modelo (evento, local, notícia) use
/// o mesmo mecanismo de persistência.
class FavoritesLocalStorage {
  static const String _key = 'cirio_favorites';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Set<String> loadAll() {
    final list = _prefs.getStringList(_key) ?? [];
    return list.toSet();
  }

  Future<void> saveAll(Set<String> favorites) async {
    await _prefs.setStringList(_key, favorites.toList());
  }

  Future<void> add(String key) async {
    final current = loadAll();
    current.add(key);
    await saveAll(current);
  }

  Future<void> remove(String key) async {
    final current = loadAll();
    current.remove(key);
    await saveAll(current);
  }
}
