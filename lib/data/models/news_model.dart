/// Modelo que representa uma notícia relacionada ao Círio.
///
/// [imageAsset] aponta para uma imagem empacotada; [imageUrl] permite que uma
/// capa publicada no Firestore seja atualizada sem lançar uma nova versão.
class NewsModel {
  final String id;
  final String title;
  final String date;
  final String summary;
  final String content;
  final String? imageAsset;
  final String? imageUrl;
  final String? titleEn;
  final String? dateEn;
  final String? summaryEn;
  final String? contentEn;
  final DateTime? publishedAt;
  final bool isPublished;
  bool isFavorite;

  NewsModel({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
    required this.content,
    this.imageAsset,
    this.imageUrl,
    this.titleEn,
    this.dateEn,
    this.summaryEn,
    this.contentEn,
    this.publishedAt,
    this.isPublished = true,
    this.isFavorite = false,
  });

  /// Converte um documento da coleção `news` para o modelo do aplicativo.
  factory NewsModel.fromMap(String id, Map<String, dynamic> map) {
    return NewsModel(
      id: id,
      title: map['title'] as String? ?? '',
      date: map['date'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      content: map['content'] as String? ?? '',
      imageAsset: map['imageAsset'] as String?,
      imageUrl: map['imageUrl'] as String?,
      titleEn: map['titleEn'] as String?,
      dateEn: map['dateEn'] as String?,
      summaryEn: map['summaryEn'] as String?,
      contentEn: map['contentEn'] as String?,
      publishedAt: map['publishedAt'] as DateTime?,
      isPublished: map['isPublished'] as bool? ?? false,
    );
  }

  /// Formato persistido no Firestore. O serviço converte [publishedAt] para
  /// `Timestamp`, mantendo este modelo independente do SDK Firebase.
  Map<String, dynamic> toMap() => {
        'title': title,
        'date': date,
        'summary': summary,
        'content': content,
        if (imageAsset != null) 'imageAsset': imageAsset,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (titleEn != null) 'titleEn': titleEn,
        if (dateEn != null) 'dateEn': dateEn,
        if (summaryEn != null) 'summaryEn': summaryEn,
        if (contentEn != null) 'contentEn': contentEn,
        if (publishedAt != null) 'publishedAt': publishedAt,
        'isPublished': isPublished,
      };

  /// Retorna uma cópia com [isFavorite] opcionalmente alterado.
  NewsModel copyWith({bool? isFavorite}) {
    return NewsModel(
      id: id,
      title: title,
      date: date,
      summary: summary,
      content: content,
      imageAsset: imageAsset,
      imageUrl: imageUrl,
      titleEn: titleEn,
      dateEn: dateEn,
      summaryEn: summaryEn,
      contentEn: contentEn,
      publishedAt: publishedAt,
      isPublished: isPublished,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
