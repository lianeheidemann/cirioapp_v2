/// Pergunta frequente que participa tanto da interface quanto do corpus RAG.
///
/// Manter uma única fonte evita divergência entre os atalhos exibidos ao
/// usuário e os documentos processados pelo gerador de embeddings.
class AiFaq {
  final String id;
  final String question;
  final String content;
  final String questionEn;
  final String contentEn;

  const AiFaq({
    required this.id,
    required this.question,
    required this.content,
    required this.questionEn,
    required this.contentEn,
  });
}

/// Perguntas frequentes usadas na interface e no corpus semântico.
///
/// [content]/[contentEn] são respostas curadas: quando o usuário toca em um
/// desses atalhos, o repositório devolve o texto diretamente, sem chamar a
/// Gemini API. Isso evita gastar duas requisições (embedding + geração) em
/// uma resposta que já é conhecida e fixa.
const List<AiFaq> aiFaqs = [
  AiFaq(
      id: 'faq_first_visit',
      question: 'Roteiro para primeira vez no Círio',
      content:
          'Para a primeira visita ao Círio, chegue cedo, combine um ponto de encontro, use roupas e calçados confortáveis, leve água e protetor solar e acompanhe as orientações dos agentes públicos. Inclua a Basílica de Nazaré, a Catedral da Sé e o centro histórico no roteiro.',
      questionEn: 'Guide for my first Círio',
      contentEn:
          'For your first visit to Círio, arrive early, agree on a meeting point with your group, wear comfortable clothes and shoes, bring water and sunscreen, and follow guidance from public safety agents. Include the Basílica de Nazaré, the Catedral da Sé, and the historic center in your itinerary.'),
  AiFaq(
      id: 'faq_hydration',
      question: 'Onde encontrar hidratação?',
      content:
          'Há pontos de hidratação cadastrados no Largo de Nazaré e na avenida Generalíssimo Deodoro. Durante as procissões, procure também os postos oficiais sinalizados e beba água antes de sentir sede.',
      questionEn: 'Where can I find hydration points?',
      contentEn:
          'Registered hydration points are located at Largo de Nazaré and Avenida Generalíssimo Deodoro. During the processions, also look for signposted official stations and drink water before you feel thirsty.'),
  AiFaq(
      id: 'faq_tourism',
      question: 'Quais locais turísticos visitar?',
      content:
          'Entre os pontos turísticos cadastrados estão a Estação das Docas, o Mercado Ver-o-Peso, o Mangal das Garças, a Basílica Santuário de Nazaré e a Catedral da Sé.',
      questionEn: 'Which tourist attractions should I visit?',
      contentEn:
          'Registered tourist attractions include Estação das Docas, Mercado Ver-o-Peso, Mangal das Garças, the Basílica Santuário de Nazaré, and the Catedral da Sé.'),
  AiFaq(
      id: 'faq_safety',
      question: 'Dicas de segurança',
      content:
          'Mantenha documentos e celular protegidos, evite levar objetos de valor, identifique crianças, combine um ponto de encontro e siga as rotas e orientações oficiais. Em emergência, procure imediatamente um agente de segurança ou posto de saúde.',
      questionEn: 'Safety tips',
      contentEn:
          'Keep your documents and phone secure, avoid carrying valuables, make sure children are identifiable, agree on a meeting point, and follow official routes and guidance. In an emergency, immediately look for a security agent or health post.'),
];
