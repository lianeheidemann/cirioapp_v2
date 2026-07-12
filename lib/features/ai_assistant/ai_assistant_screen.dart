import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import 'ai_assistant_provider.dart';

/// Tela do Assistente IA do Círio.
///
/// Permite ao usuário digitar uma pergunta livre ou escolher uma das
/// perguntas rápidas. Exibe estado de carregamento, resposta do modelo
/// e mensagens de erro. Toda a lógica fica no [AiAssistantProvider];
/// esta classe cuida apenas da apresentação.
class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendQuestion(BuildContext context, String question) {
    if (question.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<AiAssistantProvider>().askQuestion(question);
  }

  void _sendFromField(BuildContext context) {
    final question = _controller.text;
    _sendQuestion(context, question);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CirioAppBar(title: 'Assistente IA'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<AiAssistantProvider>(
                builder: (context, provider, _) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildIntro(context),
                      const SizedBox(height: 16),
                      _buildQuickQuestions(context, provider),
                      if (provider.lastQuestion != null) ...[
                        const SizedBox(height: 20),
                        _buildQuestionBubble(context, provider.lastQuestion!),
                      ],
                      if (provider.isLoading) ...[
                        const SizedBox(height: 16),
                        const Center(child: CircularProgressIndicator()),
                      ],
                      if (provider.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _buildErrorCard(context, provider.errorMessage!),
                      ],
                      if (provider.answer != null) ...[
                        const SizedBox(height: 16),
                        _buildAnswerCard(context, provider.answer!),
                      ],
                    ],
                  );
                },
              ),
            ),
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.auto_awesome, color: AppTheme.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Pergunte sobre eventos, locais, hidratação, saúde, turismo e '
            'segurança no Círio de Nazaré.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickQuestions(
    BuildContext context,
    AiAssistantProvider provider,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AiAssistantProvider.quickQuestions.map((q) {
        return ActionChip(
          label: Text(q),
          onPressed:
              provider.isLoading ? null : () => _sendQuestion(context, q),
        );
      }).toList(),
    );
  }

  Widget _buildQuestionBubble(BuildContext context, String question) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(question, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAnswerCard(BuildContext context, String answer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: AppTheme.accentGold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Consumer<AiAssistantProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: AppTheme.cardWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  enabled: !provider.isLoading,
                  onSubmitted: (_) => _sendFromField(context),
                  decoration: InputDecoration(
                    hintText: 'Digite sua pergunta sobre o Círio...',
                    filled: true,
                    fillColor: AppTheme.backgroundWhite,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed:
                    provider.isLoading ? null : () => _sendFromField(context),
                icon: provider.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        );
      },
    );
  }
}
