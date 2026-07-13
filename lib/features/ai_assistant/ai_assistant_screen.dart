import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import 'ai_assistant_provider.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});
  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String value) {
    if (value.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<AiAssistantProvider>().askQuestion(value,
        respondInEnglish: context.read<LanguageProvider>().isEnglish);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const CirioAppBar(
            title: 'Assistente IA',
            subtitle: 'Orientação para viver melhor o Círio'),
        body: SafeArea(
            child: Column(children: [
          Expanded(
              child: Consumer<AiAssistantProvider>(
                  builder: (context, p, _) => ListView(
                        controller: _scroll,
                        padding: const EdgeInsets.all(16),
                        children: [
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    AppColors.navy,
                                    AppColors.secondaryBlue
                                  ]),
                                  borderRadius: BorderRadius.circular(28)),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: .12),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: const Icon(
                                            Icons.auto_awesome_outlined,
                                            color: AppColors.gold)),
                                    const SizedBox(width: 14),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(
                                              tr(context, 'Como posso ajudar?',
                                                  'How can I help?'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                          const SizedBox(height: 6),
                                          Text(
                                              tr(
                                                  context,
                                                  'Pergunte sobre eventos, locais, turismo, saúde e segurança.',
                                                  'Ask about events, places, tourism, health and safety.'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.white70))
                                        ])),
                                  ])),
                          const SizedBox(height: 20),
                          Text(
                              tr(context, 'Sugestões para começar',
                                  'Suggestions to get started'),
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 10),
                          Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: AiAssistantProvider.quickQuestions
                                  .map((q) => ActionChip(
                                      avatar: const Icon(
                                          Icons.arrow_outward_rounded,
                                          size: 16),
                                      label:
                                          Text(_translatedQuestion(context, q)),
                                      onPressed: p.isLoading
                                          ? null
                                          : () => _send(
                                              _translatedQuestion(context, q))))
                                  .toList()),
                          if (p.lastQuestion != null) ...[
                            const SizedBox(height: 24),
                            _Bubble(text: p.lastQuestion!, user: true)
                          ],
                          if (p.isLoading) ...[
                            const SizedBox(height: 12),
                            const _ThinkingBubble()
                          ],
                          if (p.errorMessage != null) ...[
                            const SizedBox(height: 12),
                            _ErrorBubble(message: p.errorMessage!)
                          ],
                          if (p.answer != null) ...[
                            const SizedBox(height: 12),
                            _Bubble(text: p.answer!, user: false)
                          ],
                          const SizedBox(height: 16),
                        ],
                      ))),
          Consumer<AiAssistantProvider>(
              builder: (context, p, _) => Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 12,
                        10 + MediaQuery.viewPaddingOf(context).bottom),
                    decoration: const BoxDecoration(
                        color: AppColors.surface,
                        border:
                            Border(top: BorderSide(color: AppColors.divider))),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: TextField(
                                  controller: _controller,
                                  minLines: 1,
                                  maxLines: 4,
                                  enabled: !p.isLoading,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: _send,
                                  decoration: const InputDecoration(
                                      hintText: 'Pergunte sobre o Círio...',
                                      prefixIcon: Icon(
                                          Icons.chat_bubble_outline_rounded)))),
                          const SizedBox(width: 8),
                          IconButton.filled(
                              onPressed: p.isLoading
                                  ? null
                                  : () => _send(_controller.text),
                              tooltip: tr(
                                  context, 'Enviar pergunta', 'Send question'),
                              icon: p.isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.arrow_upward_rounded)),
                        ]),
                  )),
        ])),
      );
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool user;
  const _Bubble({required this.text, required this.user});
  @override
  Widget build(BuildContext context) => Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .84),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: user ? AppColors.navy : AppColors.surface,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(22),
                topRight: const Radius.circular(22),
                bottomLeft: Radius.circular(user ? 22 : 6),
                bottomRight: Radius.circular(user ? 6 : 22)),
            border: user ? null : Border.all(color: AppColors.divider)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!user) ...[
                const Icon(Icons.auto_awesome_outlined,
                    size: 19, color: AppColors.gold),
                const SizedBox(width: 9)
              ],
              Flexible(
                  child: Text(text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: user ? Colors.white : AppColors.ink)))
            ]),
      ));
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();
  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
          decoration: const BoxDecoration(
              color: AppColors.softBlue,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: 10),
                Text(tr(context, 'Pensando...', 'Thinking...'))
              ]))));
}

class _ErrorBubble extends StatelessWidget {
  final String message;
  const _ErrorBubble({required this.message});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.error.withValues(alpha: .2))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.error_outline_rounded, color: AppColors.error),
        const SizedBox(width: 10),
        Expanded(child: Text(message))
      ]));
}

String _translatedQuestion(BuildContext context, String question) {
  if (!context.read<LanguageProvider>().isEnglish) return question;
  switch (question) {
    case 'Roteiro para primeira vez no Círio':
      return 'Guide for my first Círio';
    case 'Onde encontrar hidratação?':
      return 'Where can I find hydration points?';
    case 'Quais locais turísticos visitar?':
      return 'Which tourist attractions should I visit?';
    case 'Dicas de segurança':
      return 'Safety tips';
    default:
      return question;
  }
}
