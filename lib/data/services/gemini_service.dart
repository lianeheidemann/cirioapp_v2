import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/gemini_config.dart';

/// Serviço de baixo nível para comunicação com a Gemini API.
///
/// Responsabilidade única: enviar um prompt de texto para o endpoint
/// `generateContent` e retornar a resposta textual do modelo. Não contém
/// lógica de negócio — isso fica a cargo do [AiAssistantRepository].
class GeminiService {
  final http.Client _client;

  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  /// Envia [prompt] para a Gemini API e retorna o texto gerado.
  ///
  /// Lança [GeminiServiceException] em caso de chave ausente, falha de
  /// rede, erro retornado pela API ou resposta em formato inesperado.
  Future<String> generateResponse(String prompt) async {
    if (!GeminiConfig.hasApiKey) {
      throw GeminiServiceException(
        'Chave da Gemini API não configurada. Veja o README para saber '
        'como configurá-la.',
      );
    }

    late final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(GeminiConfig.endpoint),
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': GeminiConfig.apiKey,
            },
            body: jsonEncode({
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.4,
                'maxOutputTokens': 800,
              },
            }),
          )
          .timeout(const Duration(seconds: 20));
    } catch (_) {
      throw GeminiServiceException(
        'Não foi possível conectar à Gemini API. Verifique sua internet '
        'e tente novamente.',
      );
    }

    if (response.statusCode != 200) {
      throw GeminiServiceException(
        'A Gemini API retornou um erro (${response.statusCode}). '
        'Tente novamente em instantes.',
      );
    }

    try {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw GeminiServiceException(
          'O assistente não retornou uma resposta. Tente reformular a '
          'pergunta.',
        );
      }

      final content = candidates.first['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;
      final text =
          parts?.map((p) => p['text'] ?? '').join('').toString().trim();

      if (text == null || text.isEmpty) {
        throw GeminiServiceException(
          'O assistente não retornou uma resposta. Tente reformular a '
          'pergunta.',
        );
      }

      return text;
    } on GeminiServiceException {
      rethrow;
    } catch (_) {
      throw GeminiServiceException('Resposta inesperada da Gemini API.');
    }
  }
}

/// Exceção específica para falhas na comunicação com a Gemini API.
///
/// Permite que o [AiAssistantRepository] e o [AiAssistantProvider] exibam
/// mensagens de erro amigáveis sem expor detalhes técnicos ao usuário.
class GeminiServiceException implements Exception {
  final String message;
  GeminiServiceException(this.message);

  @override
  String toString() => message;
}
