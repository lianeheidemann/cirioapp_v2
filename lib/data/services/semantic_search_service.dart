import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart';

import '../models/knowledge_embedding.dart';

/// Carrega o corpus empacotado e executa busca vetorial inteiramente no app.
///
/// O asset é lido apenas uma vez por instância. Nenhum documento do corpus é
/// enviado à API durante uma pergunta; somente o embedding da consulta chega
/// a este serviço.
class SemanticSearchService {
  static const String assetPath = 'assets/embeddings.json';
  List<KnowledgeEmbedding>? _items;
  String? _model;
  int? _dimensions;

  /// Dimensão declarada pelo gerador offline.
  ///
  /// Só fica disponível depois de [loadModel], evitando que a pergunta seja
  /// vetorizada antes de conhecermos o espaço vetorial do corpus.
  int get dimensions {
    if (_dimensions == null) {
      throw StateError('Asset de embeddings ainda não carregado.');
    }
    return _dimensions!;
  }

  /// Inicializa e devolve o modelo que produziu os vetores do asset.
  ///
  /// A consulta deve obrigatoriamente usar esse mesmo modelo. Vetores de
  /// modelos diferentes não pertencem ao mesmo espaço semântico.
  Future<String> loadModel() async {
    await _load();
    if (_model == null || _model!.isEmpty) {
      throw const FormatException('Modelo ausente no asset de embeddings.');
    }
    return _model!;
  }

  /// Ordena o corpus pela similaridade de cosseno e retorna até [limit] itens.
  ///
  /// O padrão de cinco mantém o prompt pequeno sem reduzir demais o contexto.
  Future<List<KnowledgeMatch>> search(List<double> queryEmbedding,
      {int limit = 5}) async {
    await _load();
    final matches = <KnowledgeMatch>[];
    for (final item in _items!) {
      if (item.embedding.length != queryEmbedding.length) {
        continue;
      }
      matches.add(KnowledgeMatch(
          item, cosineSimilarity(queryEmbedding, item.embedding)));
    }
    matches.sort((a, b) => b.similarity.compareTo(a.similarity));
    return matches
        .take(math.min(limit, matches.length))
        .toList(growable: false);
  }

  /// Faz o carregamento preguiçoso e valida o contrato produzido pelo script.
  Future<void> _load() async {
    if (_items != null) return;
    final json = jsonDecode(await rootBundle.loadString(assetPath))
        as Map<String, dynamic>;
    _model = json['model'] as String?;
    _dimensions = (json['dimensions'] as num?)?.toInt();
    _items = (json['items'] as List? ?? const [])
        .map(
            (item) => KnowledgeEmbedding.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    // Aceita assets antigos sem `dimensions`, inferindo pelo primeiro vetor.
    if (_dimensions == null && _items!.isNotEmpty) {
      _dimensions = _items!.first.embedding.length;
    }
    if (_dimensions == null || _dimensions! <= 0) {
      throw const FormatException('Dimensão ausente no asset de embeddings.');
    }
    // Falha cedo: ignorar vetores inválidos produziria resultados enganosos.
    if (_items!.any((item) => item.embedding.length != _dimensions)) {
      throw const FormatException(
        'O asset contém embeddings com dimensão incompatível.',
      );
    }
  }

  /// Calcula `A · B / (|A| × |B|)` sem dependências matemáticas externas.
  ///
  /// Retorna -1 para entradas inválidas; esse valor fica abaixo de qualquer
  /// correspondência útil e não é confundido com vetores ortogonais (zero).
  static double cosineSimilarity(List<double> a, List<double> b) {
    if (a.isEmpty || a.length != b.length) return -1;
    var dot = 0.0;
    var normA = 0.0;
    var normB = 0.0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    if (normA == 0 || normB == 0) return -1;
    return dot / (math.sqrt(normA) * math.sqrt(normB));
  }
}
