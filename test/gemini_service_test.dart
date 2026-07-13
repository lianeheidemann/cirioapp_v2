import 'dart:convert';

import 'package:cirio_app/core/constants/gemini_config.dart';
import 'package:cirio_app/data/services/gemini_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('usa um modelo estável em vez do alias latest', () {
    expect(GeminiConfig.model, 'gemini-3.5-flash');
    expect(GeminiConfig.endpoint, contains('gemini-3.5-flash'));
  });

  test('repete uma vez quando a Gemini retorna 503', () async {
    var calls = 0;
    final client = MockClient((request) async {
      calls++;
      if (calls == 1) {
        return http.Response(
          jsonEncode({
            'error': {'status': 'UNAVAILABLE'}
          }),
          503,
        );
      }
      return http.Response(
        jsonEncode({
          'candidates': [
            {
              'content': {
                'parts': [
                  {'text': 'Resposta disponivel'}
                ]
              }
            }
          ]
        }),
        200,
      );
    });
    final service = GeminiService(client: client, apiKey: 'test-key');

    final answer = await service.generateResponse('Pergunta');

    expect(answer, 'Resposta disponivel');
    expect(calls, 2);
  });
}
