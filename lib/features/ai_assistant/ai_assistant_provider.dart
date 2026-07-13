import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/repositories/ai_assistant_repository.dart';
import '../../data/services/gemini_service.dart';
import '../../core/constants/ai_faqs.dart';

/// Provider do Assistente IA do Círio.
///
/// Gerencia o estado da pergunta atual, resposta, carregamento e erro.
/// Expõe [askQuestion] para a [AiAssistantScreen], chamado tanto pelo
/// campo de texto livre quanto pelos botões de perguntas rápidas.
class AiAssistantProvider extends ChangeNotifier {
  final AiAssistantRepository _repository;

  AiAssistantProvider({AiAssistantRepository? repository})
      : _repository = repository ?? AiAssistantRepository();

  bool isLoading = false;
  String? errorMessage;
  String? answer;
  String? lastQuestion;
  String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Perguntas rápidas sugeridas na tela.
  static final List<String> quickQuestions =
      List.unmodifiable(aiFaqs.map((faq) => faq.question));

  /// Envia [question] ao assistente e atualiza o estado com a resposta.
  ///
  /// Ignora chamadas com texto vazio ou enquanto uma pergunta anterior
  /// ainda está sendo processada.
  Future<void> askQuestion(String question,
      {bool respondInEnglish = false}) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty || isLoading) return;

    isLoading = true;
    errorMessage = null;
    answer = null;
    lastQuestion = trimmed;
    notifyListeners();

    try {
      answer = await _repository.askQuestion(trimmed,
          respondInEnglish: respondInEnglish);
    } on GeminiServiceException catch (e) {
      errorMessage = respondInEnglish
          ? 'The AI service is unavailable right now. Check the configuration or try again.'
          : e.message;
    } catch (_) {
      errorMessage = respondInEnglish
          ? 'Unable to get an answer right now. Please try again.'
          : 'Não foi possível obter uma resposta agora. Tente novamente.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa a conversa atual (pergunta, resposta e erro).
  void clear() {
    answer = null;
    errorMessage = null;
    lastQuestion = null;
    notifyListeners();
  }
}
