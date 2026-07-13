/// Pergunta frequente que participa tanto da interface quanto do corpus RAG.
///
/// Manter uma única fonte evita divergência entre os atalhos exibidos ao
/// usuário e os documentos processados pelo gerador de embeddings.
class AiFaq {
  final String id;
  final String question;
  final String content;

  const AiFaq(
      {required this.id, required this.question, required this.content});
}

/// Perguntas frequentes usadas na interface e no corpus semântico.
const List<AiFaq> aiFaqs = [
  AiFaq(
      id: 'faq_first_visit',
      question: 'Roteiro para primeira vez no Círio',
      content:
          'Para a primeira visita ao Círio, chegue cedo, combine um ponto de encontro, use roupas e calçados confortáveis, leve água e protetor solar e acompanhe as orientações dos agentes públicos. Inclua a Basílica de Nazaré, a Catedral da Sé e o centro histórico no roteiro.'),
  AiFaq(
      id: 'faq_hydration',
      question: 'Onde encontrar hidratação?',
      content:
          'Há pontos de hidratação cadastrados no Largo de Nazaré e na avenida Generalíssimo Deodoro. Durante as procissões, procure também os postos oficiais sinalizados e beba água antes de sentir sede.'),
  AiFaq(
      id: 'faq_tourism',
      question: 'Quais locais turísticos visitar?',
      content:
          'Entre os pontos turísticos cadastrados estão a Estação das Docas, o Mercado Ver-o-Peso, o Mangal das Garças, a Basílica Santuário de Nazaré e a Catedral da Sé.'),
  AiFaq(
      id: 'faq_safety',
      question: 'Dicas de segurança',
      content:
          'Mantenha documentos e celular protegidos, evite levar objetos de valor, identifique crianças, combine um ponto de encontro e siga as rotas e orientações oficiais. Em emergência, procure imediatamente um agente de segurança ou posto de saúde.'),
];
