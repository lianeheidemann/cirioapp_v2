import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/repositories/ai_assistant_repository.dart';
import '../../data/services/gemini_service.dart';
import '../../core/constants/ai_faqs.dart';

/// Uma pergunta do usuário e o resultado correspondente (resposta ou erro).
class AiChatEntry {
  final String question;
  String? answer;
  String? errorMessage;

  AiChatEntry({required this.question, this.answer, this.errorMessage});
}

/// Provider do Assistente IA do Círio.
///
/// Mantém o histórico de toda a conversa em [history] enquanto o app não é
/// fechado — o provider é instanciado uma única vez em `main.dart` e
/// permanece vivo entre entradas/saídas da tela do assistente.
/// Expõe [askQuestion] para a [AiAssistantScreen], chamado tanto pelo
/// campo de texto livre quanto pelos botões de perguntas rápidas.
class AiAssistantProvider extends ChangeNotifier {
  final AiAssistantRepository _repository;

  AiAssistantProvider({AiAssistantRepository? repository})
      : _repository = repository ?? AiAssistantRepository();

  bool isLoading = false;
  final List<AiChatEntry> history = [];
  String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Perguntas rápidas sugeridas na tela.
  static final List<String> quickQuestions =
      List.unmodifiable(aiFaqs.map((faq) => faq.question));

  /// Envia [question] ao assistente e adiciona o resultado ao histórico.
  ///
  /// Ignora chamadas com texto vazio ou enquanto uma pergunta anterior
  /// ainda está sendo processada.
  Future<void> askQuestion(String question,
      {bool respondInEnglish = false}) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty || isLoading) return;

    final entry = AiChatEntry(question: trimmed);
    history.add(entry);
    isLoading = true;
    notifyListeners();

    try {
      entry.answer = await _repository.askQuestion(trimmed,
          respondInEnglish: respondInEnglish);
    } on GeminiServiceException catch (e) {
      entry.errorMessage = respondInEnglish
          ? 'The AI service is unavailable right now. Check the configuration or try again.'
          : e.message;
    } catch (_) {
      entry.errorMessage = respondInEnglish
          ? 'Unable to get an answer right now. Please try again.'
          : 'Não foi possível obter uma resposta agora. Tente novamente.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa toda a conversa.
  void clear() {
    history.clear();
    notifyListeners();
  }
}
