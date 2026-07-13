import '../models/news_model.dart';
import '../services/news_service.dart';

/// Repositório de notícias.
///
/// Abstrai a fonte de dados para o [NewsProvider].
class NewsRepository {
  final NewsService _service;

  NewsRepository({NewsService? service}) : _service = service ?? NewsService();

  Future<List<NewsModel>> getNews() => _service.fetchNews();
}
