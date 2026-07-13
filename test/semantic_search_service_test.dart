import 'dart:convert';

import 'package:cirio_app/data/services/semantic_search_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('similaridade de cosseno identifica vetores iguais', () {
    expect(SemanticSearchService.cosineSimilarity([1, 2, 3], [1, 2, 3]),
        closeTo(1, 1e-10));
  });

  test('similaridade de cosseno identifica vetores ortogonais', () {
    expect(SemanticSearchService.cosineSimilarity([1, 0], [0, 1]),
        closeTo(0, 1e-10));
  });

  test('dimensões incompatíveis não são comparadas', () {
    expect(SemanticSearchService.cosineSimilarity([1], [1, 2]), -1);
  });

  test('asset real retorna somente os cinco itens mais próximos', () async {
    final json = jsonDecode(
      await rootBundle.loadString(SemanticSearchService.assetPath),
    ) as Map<String, dynamic>;
    final first = (json['items'] as List).first as Map<String, dynamic>;
    final embedding = (first['embedding'] as List)
        .map((value) => (value as num).toDouble())
        .toList();

    final service = SemanticSearchService();
    expect(await service.loadModel(), json['model']);
    final matches = await service.search(embedding);

    expect(matches, hasLength(5));
    expect(matches.first.item.id, first['id']);
    expect(matches.first.similarity, closeTo(1, 1e-10));
  });
}
