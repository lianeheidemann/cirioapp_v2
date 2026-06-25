/// Modelo que representa uma notícia relacionada ao Círio.
///
/// [imageUrl] é opcional e, quando fornecido, é exibido via
/// [CachedNetworkImage] com cache automático.
class NewsModel {
  final String id;
  final String title;
  final String date;
  final String summary;
  final String content;
  final String? imageUrl;
  bool isFavorite;

  NewsModel({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
    required this.content,
    this.imageUrl,
    this.isFavorite = false,
  });

  /// Retorna uma cópia com [isFavorite] opcionalmente alterado.
  NewsModel copyWith({bool? isFavorite}) {
    return NewsModel(
      id: id,
      title: title,
      date: date,
      summary: summary,
      content: content,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
