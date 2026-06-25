import '../models/news_model.dart';

/// Serviço de dados das notícias.
///
/// Mock com latência simulada. Substituir por feed RSS ou API REST.
class NewsService {
  Future<List<NewsModel>> fetchNews() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      NewsModel(
        id: 'n1',
        title: 'Círio 2025 espera receber 2,5 milhões de fiéis',
        date: '28 de setembro de 2025',
        summary:
            'Organização prevê recorde de público para a maior procissão católica do Brasil.',
        imageUrl: 'https://picsum.photos/seed/cirio1/800/400',
        content:
            'A Arquidiocese de Belém divulgou estimativa de 2,5 milhões de '
            'participantes para o Círio de Nazaré 2025. O planejamento inclui '
            'reforço no sistema de saúde, com 120 postos de atendimento médico '
            'ao longo do percurso de 3,6 km. A Guarda Municipal e Polícia '
            'Militar mobilizarão cerca de 3.000 agentes para garantir a '
            'segurança dos peregrinos. O prefeito de Belém confirmou '
            'investimento de R\$ 8 milhões em infraestrutura, incluindo novos '
            'pontos de hidratação e sanitários portáteis.',
      ),
      NewsModel(
        id: 'n2',
        title: 'Corda do Círio: tradição que une peregrinos há séculos',
        date: '05 de outubro de 2025',
        summary:
            'Entenda o significado e a história da famosa corda que guia a '
            'procissão do Círio.',
        imageUrl: 'https://picsum.photos/seed/cirio2/800/400',
        content:
            'A corda do Círio é muito mais do que um elemento organizacional '
            'da procissão. Com cerca de 400 metros de comprimento, ela '
            'representa o elo espiritual entre os fiéis e Nossa Senhora de '
            'Nazaré. A tradição de puxar a corda surgiu ainda no século XIX '
            'como forma de os devotos se manterem próximos à berlinda com a '
            'imagem da santa. Hoje, grupos familiares, associações e '
            'comunidades disputam o privilégio de segurar a corda, que é '
            'renovada a cada ano com novas fibras mas mantém pedaços da corda '
            'antiga como relíquias.',
      ),
      NewsModel(
        id: 'n3',
        title: 'Gastronomia paraense invade o Círio: o que comer em Belém',
        date: '08 de outubro de 2025',
        summary:
            'Do maniçoba ao pato no tucupi, a culinária local é parte '
            'fundamental da festa.',
        imageUrl: 'https://picsum.photos/seed/cirio3/800/400',
        content:
            'A culinária paraense é protagonista durante o período do Círio. '
            'O almoço do Círio, realizado nas casas de família no domingo da '
            'procissão, reúne pratos tradicionais como maniçoba (cozida por '
            'dias), pato no tucupi, caruru e vatapá. O Ver-o-Peso, maior feira '
            'ao ar livre da América Latina, concentra as melhores opções '
            'gastronômicas para turistas. O açaí paraense, servido grosso e '
            'sem adição de açúcar, é experiência obrigatória. A Estação das '
            'Docas oferece restaurantes com vista para o rio e cardápio '
            'regional sofisticado.',
      ),
      NewsModel(
        id: 'n4',
        title: 'Programa cultural do Círio tem mais de 50 eventos gratuitos',
        date: '01 de outubro de 2025',
        summary:
            'Shows, exposições e atividades culturais movimentam Belém durante '
            'todo o mês de outubro.',
        imageUrl: 'https://picsum.photos/seed/cirio4/800/400',
        content:
            'A Prefeitura de Belém divulgou a programação cultural do Círio '
            '2025, com mais de 50 eventos gratuitos espalhados pela cidade. '
            'Destaques incluem a Expo Círio no Hangar Centro de Convenções, '
            'com artesanato e gastronomia regional; o Festival de Música Sacra '
            'na Basílica Santuário; e shows nacionais no Largo de Nazaré na '
            'véspera da procissão. Teatros e museus de Belém participam com '
            'programação especial e entrada gratuita durante a quadra nazarena.',
      ),
      NewsModel(
        id: 'n5',
        title: 'Como se preparar para participar do Círio com segurança',
        date: '10 de outubro de 2025',
        summary:
            'Dicas essenciais para quem vai participar da procissão pela '
            'primeira vez.',
        imageUrl: 'https://picsum.photos/seed/cirio5/800/400',
        content:
            'Participar do Círio exige preparo físico e logístico. '
            'Especialistas recomendam: usar roupas leves e calçados '
            'confortáveis; levar água e protetor solar; evitar o centro do '
            'percurso se você tem claustrofobia; combinar ponto de encontro '
            'com o grupo antes de sair; manter documentos e celular em bolso '
            'interno; chegar cedo ao ponto de saída para garantir boa posição. '
            'O percurso dura em média 4 horas, com sol forte no início da '
            'manhã. Idosos e crianças pequenas devem acompanhar de pontos '
            'fixos ao longo do trajeto.',
      ),
    ];
  }
}
