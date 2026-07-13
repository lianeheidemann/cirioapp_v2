/// Modelo que representa uma notícia relacionada ao Círio.
///
/// [imageAsset] é opcional e aponta para uma imagem empacotada com o app.
class NewsModel {
  final String id;
  final String title;
  final String date;
  final String summary;
  final String content;
  final String? imageAsset;
  bool isFavorite;

  NewsModel({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
    required this.content,
    this.imageAsset,
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
      imageAsset: imageAsset,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
