import 'package:cirio_app/data/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converte documento Firestore com campos remotos e traduções', () {
    final publishedAt = DateTime.utc(2026, 7, 13);
    final news = NewsModel.fromMap('news-1', {
      'title': 'Título',
      'date': '13 de julho de 2026',
      'summary': 'Resumo',
      'content': 'Conteúdo',
      'imageUrl': 'https://example.com/news.jpg',
      'titleEn': 'Title',
      'publishedAt': publishedAt,
      'isPublished': true,
    });

    expect(news.id, 'news-1');
    expect(news.imageUrl, 'https://example.com/news.jpg');
    expect(news.titleEn, 'Title');
    expect(news.publishedAt, publishedAt);
    expect(news.isPublished, isTrue);
  });

  test('documento sem isPublished é tratado como rascunho', () {
    final news = NewsModel.fromMap('draft', {
      'title': 'Rascunho',
      'date': '',
      'summary': '',
      'content': '',
    });

    expect(news.isPublished, isFalse);
  });
}
