import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuração de acesso à Gemini API.
///
/// A chave da API NUNCA deve ser commitada no código-fonte. Este arquivo
/// concentra toda a configuração sensível em um único lugar, separado de
/// [AppConstants], para facilitar auditoria e substituição futura por uma
/// solução mais segura (ex: variáveis de build por ambiente, backend proxy).
///
/// Como fornecer a chave (veja detalhes completos no README):
///
/// 1) RECOMENDADO — variável de ambiente do Dart, em tempo de build/execução:
///    ```
///    flutter run --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
///    flutter build apk --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
///    ```
///
/// 2) ALTERNATIVA (dev local) — preencher `GEMINI_API_KEY` no arquivo
///    `.env` na raiz do projeto (já carregado em `main.dart` via
///    `flutter_dotenv`). **Nunca faça commit** do `.env` com uma chave real
///    — mantenha-o no `.gitignore`.
///
/// 3) ALTERNATIVA (apenas para testes locais rápidos) — preencher
///    [fallbackApiKey] manualmente neste arquivo. Nesse caso, **não faça
///    commit** do valor real: mantenha-o vazio antes de subir o código.
class GeminiConfig {
  GeminiConfig._();

  /// Chave lida da variável de ambiente `GEMINI_API_KEY` (via --dart-define).
  static const String _envApiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Chave lida do arquivo `.env` (via flutter_dotenv), quando presente.
  static String get _dotenvApiKey {
    try {
      return dotenv.env['GEMINI_API_KEY'] ?? '';
    } catch (_) {
      // dotenv pode não estar inicializado (ex.: testes unitários).
      return '';
    }
  }

  /// Chave temporária para uso local em desenvolvimento.
  /// Mantenha vazio em commits — use --dart-define ou .env em vez disso.
  static const String fallbackApiKey = '';

  /// Chave efetiva utilizada pelo [GeminiService].
  ///
  /// Ordem de prioridade: --dart-define > .env > fallbackApiKey.
  static String get apiKey {
    if (_envApiKey.isNotEmpty) return _envApiKey;
    if (_dotenvApiKey.isNotEmpty) return _dotenvApiKey;
    return fallbackApiKey;
  }

  /// Indica se alguma chave foi configurada (por env ou fallback).
  static bool get hasApiKey => apiKey.isNotEmpty;

  /// Modelo do Gemini utilizado nas chamadas.
  ///
  /// Um identificador estável evita mudanças inesperadas de latência e
  /// disponibilidade causadas pelo alias `latest`.
  static const String model = 'gemini-3.5-flash';

  /// Modelo de embeddings usado ao gerar um corpus novo. Em runtime, o app
  /// usa o modelo registrado no próprio asset para manter os vetores compatíveis.
  static const String embeddingModel = String.fromEnvironment(
    'GEMINI_EMBEDDING_MODEL',
    defaultValue: 'gemini-embedding-001',
  );

  /// Endpoint REST de geração de conteúdo (generateContent) da Gemini API.
  static String get endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';

  static String embeddingEndpoint(String modelName) =>
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '$modelName:embedContent';
}
