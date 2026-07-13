/// Documento do corpus local acompanhado do vetor calculado offline.
///
/// [type] identifica a origem (`evento`, `local`, `notícia` ou `faq`) e permite que o
/// prompt preserve essa informação sem depender dos modelos de cada feature.
class KnowledgeEmbedding {
  final String id;
  final String type;
  final String title;
  final String content;
  final List<double> embedding;

  const KnowledgeEmbedding(
      {required this.id,
      required this.type,
      required this.title,
      required this.content,
      required this.embedding});

  /// Converte os números do JSON para `double`, pois `jsonDecode` pode
  /// representar valores sem casas decimais como `int`.
  factory KnowledgeEmbedding.fromJson(Map<String, dynamic> json) =>
      KnowledgeEmbedding(
        id: json['id'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        embedding: (json['embedding'] as List)
            .map((value) => (value as num).toDouble())
            .toList(growable: false),
      );
}

/// Resultado do ranking local: documento encontrado e seu cosseno com a busca.
class KnowledgeMatch {
  final KnowledgeEmbedding item;
  final double similarity;
  const KnowledgeMatch(this.item, this.similarity);
}
