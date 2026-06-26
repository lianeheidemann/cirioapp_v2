import 'package:cirio_app/core/constants/app_constants.dart';
import 'package:cirio_app/data/models/event_model.dart';
import 'package:cirio_app/data/models/news_model.dart';
import 'package:cirio_app/data/models/place_model.dart';
import 'package:cirio_app/data/services/event_service.dart';
import 'package:cirio_app/data/services/news_service.dart';
import 'package:cirio_app/data/services/place_service.dart';

/// Serviços fake sem latência para testes.
class FakeEventService extends EventService {
  @override
  Future<List<EventModel>> fetchEvents() async => [
        EventModel(
          id: 'e1',
          title: 'Círio de Nazaré',
          date: '11 de outubro de 2026',
          time: '07:00',
          location: 'Colégio Gentil Bittencourt',
          category: 'Procissão',
          description: 'Maior procissão do Brasil.',
        ),
        EventModel(
          id: 'e2',
          title: 'Trasladação',
          date: '10 de outubro de 2026',
          time: '17:00',
          location: 'Basílica Santuário de Nazaré',
          category: 'Procissão',
          description: 'Início das festividades.',
        ),
      ];
}

class FakePlaceService extends PlaceService {
  @override
  Future<List<PlaceModel>> fetchPlaces() async => [
        PlaceModel(
          id: 'p1',
          name: 'Basílica Santuário de Nazaré',
          category: AppConstants.categoryChurch,
          address: 'Praça Justo Chermont — Nazaré, Belém',
          description: 'Principal ponto do Círio.',
          latitude: -1.4558,
          longitude: -48.5044,
        ),
      ];
}

class FakeNewsService extends NewsService {
  @override
  Future<List<NewsModel>> fetchNews() async => [
        NewsModel(
          id: 'n1',
          title: 'Círio 2026 espera 2,5 milhões de fiéis',
          date: '28 de setembro de 2026',
          summary: 'Estimativa de público recorde.',
          content: 'Conteúdo completo da notícia.',
        ),
      ];
}
