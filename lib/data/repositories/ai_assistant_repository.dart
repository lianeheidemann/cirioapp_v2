import '../local/ai_response_cache.dart';
import '../models/knowledge_embedding.dart';
import '../services/gemini_service.dart';
import '../services/semantic_search_service.dart';

/// Orquestra cache, recuperação semântica local e geração da resposta.
///
/// Fluxo de uma consulta:
/// 1. carrega modelo/dimensão do corpus;
/// 2. gera um único embedding para a pergunta;
/// 3. tenta reutilizar uma resposta semanticamente equivalente;
/// 4. em cache miss, recupera o top-5 e chama `generateContent`.
class AiAssistantRepository {
  final GeminiService _geminiService;
  final SemanticSearchService _semanticSearch;
  final AiResponseCache _responseCache;

  AiAssistantRepository({
    GeminiService? geminiService,
    SemanticSearchService? semanticSearch,
    AiResponseCache? responseCache,
  })  : _geminiService = geminiService ?? GeminiService(),
        _semanticSearch = semanticSearch ?? SemanticSearchService(),
        _responseCache = responseCache ?? AiResponseCache();

  static const String _systemInstruction =
      'Você é o Assistente IA do CírioApp, especializado exclusivamente no '
      'Círio de Nazaré e na cidade de Belém do Pará. Responda apenas sobre '
      'esses temas (programação, locais, turismo, hidratação, saúde, '
      'segurança e notícias relacionadas ao Círio). Se a pergunta fugir '
      'completamente desse escopo, explique educadamente que você só pode '
      'ajudar com assuntos do Círio de Nazaré e de Belém. Não invente dados '
      'ausentes do contexto. Responda de forma clara, objetiva e útil, em no '
      'máximo alguns parágrafos curtos ou uma lista. Em orientações de saúde '
      'ou segurança, recomende ajuda oficial quando não forem dicas gerais.';

  /// Responde à pergunta usando no máximo uma chamada de embedding e, apenas
  /// quando não houver cache hit, uma chamada de geração de conteúdo.
  Future<String> askQuestion(String question,
      {bool respondInEnglish = false}) async {
    final embeddingModel = await _semanticSearch.loadModel();

    // Esta é a única chamada de embedding feita durante uma pergunta.
    final questionEmbedding = await _geminiService.embedQuestion(
      question,
      model: embeddingModel,
      dimensions: _semanticSearch.dimensions,
    );
    final language = respondInEnglish ? 'en' : 'pt';

    // O mesmo vetor serve para consultar o cache e o corpus; não há uma
    // segunda chamada de embedding dentro deste fluxo.
    final cached = await _responseCache.find(
      questionEmbedding,
      language: language,
      model: embeddingModel,
    );
    if (cached != null) return cached.answer;

    final matches = await _semanticSearch.search(questionEmbedding, limit: 5);
    final prompt = _buildPrompt(
      matches: matches,
      question: question,
      respondInEnglish: respondInEnglish,
    );
    final answer = await _geminiService.generateResponse(prompt);

    // Salvar somente após uma geração bem-sucedida evita cachear erros ou
    // respostas incompletas retornadas por exceções de rede.
    await _responseCache.save(
      question: question,
      embedding: questionEmbedding,
      answer: answer,
      language: language,
      model: embeddingModel,
    );
    return answer;
  }

  /// Monta um prompt curto com instrução estável e somente o contexto ranqueado.
  String _buildPrompt(
      {required List<KnowledgeMatch> matches,
      required String question,
      required bool respondInEnglish}) {
    final languageInstruction = respondInEnglish
        ? 'Answer entirely in English.'
        : 'Responda integralmente em português.';
    final context = matches.isEmpty
        ? 'Nenhum item local relevante foi encontrado.'
        : matches
            .map((match) =>
                '[${match.item.type}] ${match.item.title}\n${match.item.content}')
            .join('\n\n');

    return '''
$_systemInstruction
$languageInstruction

Use somente os itens relevantes abaixo como fonte de dados locais. Ignore-os
quando não ajudarem a responder à pergunta:
$context

Pergunta do usuário:
$question
''';
  }
}
