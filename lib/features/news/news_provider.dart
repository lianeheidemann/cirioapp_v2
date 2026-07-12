import 'package:flutter/material.dart';
import '../../data/models/news_model.dart';
import '../../data/repositories/news_repository.dart';
import '../../core/constants/app_constants.dart';
import '../favorites/favorites_provider.dart';

/// Provider da tela de notícias.
///
/// Carrega artigos do [NewsRepository] e sincroniza favoritos.
/// Expõe [news] e [isLoading] para a UI.
class NewsProvider extends ChangeNotifier {
  final NewsRepository _repository;
  FavoritesProvider _favoritesProvider;

  List<NewsModel> _news = [];
  bool isLoading = false;
  String? errorMessage;

  NewsProvider(this._repository, this._favoritesProvider);

  List<NewsModel> get news => _news;

  void updateFavorites(FavoritesProvider favs) {
    _favoritesProvider = favs;
    _syncFavorites();
    notifyListeners();
  }

  /// Busca notícias do repositório.
  Future<void> loadNews() async {
    if (isLoading || _news.isNotEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _news = await _repository.getNews();
      _syncFavorites();
    } catch (e) {
      errorMessage = 'Não foi possível carregar as notícias.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _syncFavorites() {
    for (var i = 0; i < _news.length; i++) {
      _news[i] = _news[i].copyWith(
        isFavorite: _favoritesProvider.isFavorite(
          AppConstants.favoriteTypeNews,
          _news[i].id,
        ),
      );
    }
  }

  Future<void> toggleFavorite(NewsModel news) async {
    await _favoritesProvider.toggle(AppConstants.favoriteTypeNews, news.id);
  }

  List<NewsModel> getFavoriteNews() {
    final ids = _favoritesProvider.getIdsByType(AppConstants.favoriteTypeNews);
    return _news.where((n) => ids.contains(n.id)).toList();
  }
}
