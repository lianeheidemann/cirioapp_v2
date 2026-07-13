import '../../core/firebase/firebase_bootstrap.dart';
import '../models/news_model.dart';
import '../services/firestore_news_service.dart';
import '../services/news_service.dart';

/// Repositório de notícias.
///
/// Abstrai a fonte de dados para o [NewsProvider].
class NewsRepository {
  final NewsService _service;

  NewsRepository({NewsService? service})
      : _service = service ??
            (FirebaseBootstrap.isAvailable
                ? FirestoreNewsService()
                : LocalNewsService());

  Future<List<NewsModel>> getNews() => _service.fetchNews();

  Stream<List<NewsModel>> watchNews() => _service.watchNews();
}
