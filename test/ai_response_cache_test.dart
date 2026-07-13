import 'package:cirio_app/data/local/ai_response_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('reutiliza resposta para pergunta semanticamente semelhante', () async {
    final cache = AiResponseCache();
    await cache.save(
      question: 'Onde há água?',
      embedding: [1, 0],
      answer: 'No ponto de hidratação.',
      language: 'pt',
      model: 'test-model',
    );

    final hit = await cache.find(
      [0.999, 0.001],
      language: 'pt',
      model: 'test-model',
    );

    expect(hit?.answer, 'No ponto de hidratação.');
    expect(hit?.similarity, greaterThanOrEqualTo(0.94));
  });

  test('não mistura respostas de idiomas diferentes', () async {
    final cache = AiResponseCache();
    await cache.save(
      question: 'Onde há água?',
      embedding: [1, 0],
      answer: 'No ponto de hidratação.',
      language: 'pt',
      model: 'test-model',
    );

    expect(
      await cache.find([1, 0], language: 'en', model: 'test-model'),
      isNull,
    );
  });
}
