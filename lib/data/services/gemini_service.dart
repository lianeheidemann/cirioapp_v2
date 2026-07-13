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
        _messageForError(response.statusCode, response.bodyBytes),
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

  /// Gera somente o embedding da pergunta. O corpus é vetorizado offline.
  ///
  /// [model] e [dimensions] vêm do asset, não de uma constante independente.
  /// Assim uma atualização do corpus nunca compara vetores incompatíveis.
  Future<List<double>> embedQuestion(String text,
      {required String model, required int dimensions}) async {
    if (!GeminiConfig.hasApiKey) {
      throw GeminiServiceException(
        'Chave da Gemini API não configurada. Veja o README para configurá-la.',
      );
    }

    late final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(GeminiConfig.embeddingEndpoint(model)),
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': GeminiConfig.apiKey,
            },
            body: jsonEncode({
              'content': {
                'parts': [
                  {'text': text},
                ],
              },
              // Consultas e documentos usam task types complementares para
              // melhorar a recuperação assimétrica recomendada pela Gemini.
              'taskType': 'RETRIEVAL_QUERY',
              'outputDimensionality': dimensions,
            }),
          )
          .timeout(const Duration(seconds: 20));
    } catch (_) {
      throw GeminiServiceException(
        'Não foi possível gerar a busca semântica. Verifique sua internet.',
      );
    }

    if (response.statusCode != 200) {
      throw GeminiServiceException(
        _messageForError(response.statusCode, response.bodyBytes),
      );
    }

    try {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final values =
          (data['embedding'] as Map<String, dynamic>)['values'] as List;
      final embedding = values
          .map((value) => (value as num).toDouble())
          .toList(growable: false);
      if (embedding.length != dimensions) {
        throw GeminiServiceException(
          'A Gemini retornou um embedding com dimensão incompatível.',
        );
      }
      return embedding;
    } on GeminiServiceException {
      rethrow;
    } catch (_) {
      throw GeminiServiceException('Embedding inesperado da Gemini API.');
    }
  }

  /// Traduz o erro retornado pela Gemini API em uma mensagem clara para o
  /// usuário final, com base no [statusCode] HTTP e no `status` (código de
  /// erro do Google, ex: "RESOURCE_EXHAUSTED") presente no corpo da
  /// resposta, quando disponível.
  String _messageForError(int statusCode, List<int> bodyBytes) {
    String? googleStatus;
    try {
      final data = jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
      googleStatus =
          (data['error'] as Map<String, dynamic>?)?['status'] as String?;
    } catch (_) {
      // Corpo não veio em JSON (ou formato inesperado); segue só com o
      // código HTTP.
    }

    switch (googleStatus) {
      case 'INVALID_ARGUMENT':
        return 'A pergunta enviada não pôde ser processada (formato '
            'inválido). Tente reformular.';
      case 'PERMISSION_DENIED':
        return 'A chave da Gemini API não tem permissão para usar este '
            'recurso. Verifique se a chave está correta e ativa.';
      case 'NOT_FOUND':
        return 'O modelo de IA configurado não está mais disponível. É '
            'preciso atualizar o app para usar um modelo atual.';
      case 'RESOURCE_EXHAUSTED':
        return 'O limite de uso gratuito da Gemini API foi atingido por '
            'hoje. Tente novamente mais tarde.';
      case 'UNAVAILABLE':
        return 'O assistente de IA está sobrecarregado no momento. '
            'Aguarde alguns instantes e tente novamente.';
      case 'DEADLINE_EXCEEDED':
        return 'O assistente demorou demais para responder. Tente '
            'novamente.';
      case 'INTERNAL':
        return 'Ocorreu um erro interno no servidor da Gemini API. Tente '
            'novamente em instantes.';
    }

    // Sem status reconhecido: cai para uma mensagem genérica baseada no
    // código HTTP.
    switch (statusCode) {
      case 400:
        return 'A pergunta enviada não pôde ser processada. Tente '
            'reformular.';
      case 401:
      case 403:
        return 'Problema com a chave da Gemini API. Verifique se ela está '
            'correta e ativa.';
      case 404:
        return 'O modelo de IA configurado não está mais disponível.';
      case 429:
        return 'Limite de uso da Gemini API atingido. Tente novamente mais '
            'tarde.';
      case 503:
        return 'O assistente de IA está sobrecarregado no momento. '
            'Tente novamente em instantes.';
      default:
        return 'A Gemini API retornou um erro ($statusCode). Tente '
            'novamente em instantes.';
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
