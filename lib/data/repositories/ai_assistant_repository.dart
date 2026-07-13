import '../models/event_model.dart';
import '../models/place_model.dart';
import '../repositories/event_repository.dart';
import '../repositories/place_repository.dart';
import '../services/gemini_service.dart';

/// Repositório do Assistente IA do Círio.
///
/// Abstrai a origem dos dados para o [AiAssistantProvider]. Monta um
/// contexto textual resumido a partir dos dados já existentes no app
/// (eventos e locais) e delega a chamada ao modelo para o [GeminiService].
///
/// Não implementa RAG real nem busca vetorial: o contexto é montado de
/// forma simples, resumindo todos os itens disponíveis em texto plano.
class AiAssistantRepository {
  final GeminiService _geminiService;
  final EventRepository _eventRepository;
  final PlaceRepository _placeRepository;

  AiAssistantRepository({
    GeminiService? geminiService,
    EventRepository? eventRepository,
    PlaceRepository? placeRepository,
  })  : _geminiService = geminiService ?? GeminiService(),
        _eventRepository = eventRepository ?? EventRepository(),
        _placeRepository = placeRepository ?? PlaceRepository();

  /// Instrução de sistema: define escopo e postura do assistente.
  static const String _systemInstruction =
      'Você é o Assistente IA do CírioApp, especializado exclusivamente no '
      'Círio de Nazaré e na cidade de Belém do Pará. Responda apenas sobre '
      'esses temas (programação, locais, turismo, hidratação, saúde, '
      'segurança e notícias relacionadas ao Círio). Se a pergunta fugir '
      'completamente desse escopo, explique educadamente que você só pode '
      'ajudar com assuntos do Círio de Nazaré e de Belém. Responda sempre '
      'em português, de forma clara, objetiva e útil, em no máximo alguns '
      'parágrafos curtos ou uma lista. Ao dar orientações de saúde ou '
      'segurança, seja prudente: recomende procurar um posto de saúde ou '
      'agente de segurança oficial em casos que fujam de dicas gerais.';

  /// Envia a [question] do usuário ao Gemini, já com contexto do app.
  Future<String> askQuestion(String question,
      {bool respondInEnglish = false}) async {
    final context = await _buildContext();
    final prompt = _buildPrompt(
        context: context,
        question: question,
        respondInEnglish: respondInEnglish);
    return _geminiService.generateResponse(prompt);
  }

  /// Monta um resumo textual curto dos eventos e locais cadastrados no app.
  Future<String> _buildContext() async {
    final buffer = StringBuffer();

    try {
      final events = await _eventRepository.getEvents();
      buffer.writeln('Programação de eventos do Círio:');
      for (final e in events) {
        buffer.writeln(_summarizeEvent(e));
      }
    } catch (_) {
      // Contexto é um complemento; se falhar, seguimos sem ele.
    }

    try {
      final places = await _placeRepository.getPlaces();
      buffer.writeln();
      buffer.writeln('Locais e pontos de interesse cadastrados:');
      for (final p in places) {
        buffer.writeln(_summarizePlace(p));
      }
    } catch (_) {
      // Idem: segue sem esse trecho do contexto em caso de falha.
    }

    return buffer.toString();
  }

  String _summarizeEvent(EventModel e) =>
      '- ${e.title} (${e.category}): ${e.date} às ${e.time}, em '
      '${e.location}.';

  String _summarizePlace(PlaceModel p) =>
      '- ${p.name} (${p.category}): ${p.address}.';

  String _buildPrompt(
      {required String context,
      required String question,
      required bool respondInEnglish}) {
    final languageInstruction = respondInEnglish
        ? 'Answer entirely in English.'
        : 'Responda integralmente em português.';
    return '''
$_systemInstruction
$languageInstruction

Dados disponíveis no app para embasar sua resposta (use quando forem
relevantes; não é necessário mencionar todos):
$context

Pergunta do usuário:
$question
''';
  }
}
