import '../models/event_model.dart';

/// Serviço de dados dos eventos.
///
/// Atualmente retorna dados mockados com latência simulada.
/// No futuro, substituir por chamada HTTP real (REST API).
class EventService {
  Future<List<EventModel>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      EventModel(
        id: 'e1',
        title: 'Trasladação da Imagem',
        date: '10 de outubro de 2026',
        time: '17:00',
        location: 'Basílica Santuário de Nazaré',
        category: 'Procissão',
        description:
            'Procissão que transfere a imagem de Nossa Senhora de Nazaré da Catedral da Sé para a Basílica Santuário, marcando o início oficial das festividades do Círio.',
      ),
      EventModel(
        id: 'e2',
        title: 'Círio de Nazaré',
        date: '11 de outubro de 2026',
        time: '07:00',
        location: 'Saída: Colégio Gentil Bittencourt',
        category: 'Procissão',
        description:
            'A maior procissão do Brasil, com mais de 2 milhões de fiéis acompanhando a imagem de Nossa Senhora de Nazaré pelas ruas de Belém. Saída do Colégio Gentil Bittencourt com chegada à Basílica Santuário.',
      ),
      EventModel(
        id: 'e3',
        title: 'Missa de Abertura da Quadra Nazarena',
        date: '01 de outubro de 2026',
        time: '19:00',
        location: 'Basílica Santuário de Nazaré',
        category: 'Missa',
        description:
            'Missa solene que marca o início do mês do Círio, com celebração presidida pelo Arcebispo de Belém e transmissão ao vivo pela TV Nazaré.',
      ),
      EventModel(
        id: 'e4',
        title: 'Festa da Chiquita',
        date: '10 de outubro de 2026',
        time: '18:00',
        location: 'Largo de Nazaré',
        category: 'Cultural',
        description:
            'Manifestação popular e cultural que acontece na véspera do Círio, reunindo bandas de música, barracas de comida típica e shows no entorno da Basílica.',
      ),
      EventModel(
        id: 'e5',
        title: 'Recírio',
        date: '18 de outubro de 2026',
        time: '07:00',
        location: 'Basílica Santuário de Nazaré',
        category: 'Procissão',
        description:
            'Procissão de retorno da imagem, encerrando o ciclo do Círio de 2026. Percurso da Basílica até o Ver-o-Peso, passando pelo centro histórico de Belém.',
      ),
      EventModel(
        id: 'e6',
        title: 'Missa das Crianças',
        date: '05 de outubro de 2026',
        time: '09:00',
        location: 'Basílica Santuário de Nazaré',
        category: 'Missa',
        description:
            'Celebração especial dedicada às crianças, com linguagem acessível, encenações e participação ativa dos pequenos fiéis.',
      ),
    ];
  }
}
