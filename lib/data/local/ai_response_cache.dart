import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/semantic_search_service.dart';

/// Resposta recuperada do cache e a confiança semântica da correspondência.
class AiCachedResponse {
  final String answer;
  final double similarity;
  const AiCachedResponse(this.answer, this.similarity);
}

/// Cache semântico persistido no dispositivo com `SharedPreferences`.
///
/// Além do idioma, o modelo faz parte da chave lógica: misturar embeddings de
/// modelos distintos invalidaria a comparação. O cache usa uma lista pequena
/// porque a busca atual é linear e deve permanecer barata em aparelhos móveis.
class AiResponseCache {
  static const String _storageKey = 'ai_semantic_response_cache_v1';
  static const int _maxEntries = 50;
  static const double defaultSimilarityThreshold = 0.94;

  /// Procura a pergunta anterior mais próxima que alcance [threshold].
  ///
  /// Um limiar alto reduz o risco de reutilizar uma resposta para perguntas
  /// apenas relacionadas, mas com intenção diferente.
  Future<AiCachedResponse?> find(List<double> questionEmbedding,
      {required String language,
      required String model,
      double threshold = defaultSimilarityThreshold}) async {
    final entries = await _readEntries();
    Map<String, dynamic>? best;
    var bestScore = threshold;
    for (final entry in entries) {
      // Respostas em outro idioma ou espaço vetorial nunca são candidatas.
      if (entry['language'] != language || entry['model'] != model) {
        continue;
      }
      final cachedEmbedding = (entry['embedding'] as List?)
          ?.map((value) => (value as num).toDouble())
          .toList(growable: false);
      if (cachedEmbedding == null ||
          cachedEmbedding.length != questionEmbedding.length) {
        continue;
      }
      final score = SemanticSearchService.cosineSimilarity(
          questionEmbedding, cachedEmbedding);
      if (score >= bestScore) {
        best = entry;
        bestScore = score;
      }
    }
    final answer = best?['answer'] as String?;
    return answer == null ? null : AiCachedResponse(answer, bestScore);
  }

  /// Insere a resposta mais recente no início e aplica o limite do cache.
  Future<void> save(
      {required String question,
      required List<double> embedding,
      required String answer,
      required String language,
      required String model}) async {
    final preferences = await SharedPreferences.getInstance();
    final entries = await _readEntries(preferences);
    entries.insert(0, {
      'question': question,
      'embedding': embedding,
      'answer': answer,
      'language': language,
      'model': model,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    });
    if (entries.length > _maxEntries) {
      entries.removeRange(_maxEntries, entries.length);
    }
    await preferences.setString(_storageKey, jsonEncode(entries));
  }

  /// Lê o cache de forma tolerante: dados antigos ou corrompidos não devem
  /// impedir o assistente de gerar uma nova resposta.
  Future<List<Map<String, dynamic>>> _readEntries(
      [SharedPreferences? preferences]) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
