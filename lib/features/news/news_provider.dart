import 'dart:async';

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
  StreamSubscription<List<NewsModel>>? _newsSubscription;
  bool isLoading = false;
  String? errorMessage;

  NewsProvider(this._repository, this._favoritesProvider);

  List<NewsModel> get news => _news;

  void updateFavorites(FavoritesProvider favs) {
    _favoritesProvider = favs;
    _syncFavorites();
    notifyListeners();
  }

  /// Inicia a assinatura das notícias. No Firestore, inserções e edições
  /// publicadas chegam à interface sem precisar reiniciar o aplicativo.
  Future<void> loadNews() async {
    if (isLoading || _newsSubscription != null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    _newsSubscription = _repository.watchNews().listen(
      (items) {
        _news = items;
        _syncFavorites();
        isLoading = false;
        errorMessage = null;
        notifyListeners();
      },
      onError: (Object _) {
        final failedSubscription = _newsSubscription;
        _newsSubscription = null;
        unawaited(failedSubscription?.cancel());
        isLoading = false;
        errorMessage = 'Não foi possível carregar as notícias.';
        notifyListeners();
      },
      cancelOnError: true,
    );
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

  @override
  void dispose() {
    unawaited(_newsSubscription?.cancel());
    super.dispose();
  }
}
