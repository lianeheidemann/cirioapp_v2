import '../models/place_model.dart';
import '../../core/constants/app_constants.dart';

/// Serviço de dados dos pontos de interesse.
///
/// Retorna locais com coordenadas geográficas para exibição no mapa.
/// Mock atual — substituir por API real em produção.
class PlaceService {
  Future<List<PlaceModel>> fetchPlaces() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      PlaceModel(
        id: 'p1',
        name: 'Basílica Santuário de Nazaré',
        category: AppConstants.categoryChurch,
        address: 'Praça Justo Chermont, s/n — Nazaré, Belém',
        description:
            'Principal ponto de chegada do Círio, onde a imagem de Nossa Senhora de Nazaré fica exposta para visitação durante todo o mês de outubro.',
        latitude: -1.4558,
        longitude: -48.5044,
      ),
      PlaceModel(
        id: 'p2',
        name: 'Catedral da Sé',
        category: AppConstants.categoryChurch,
        address: 'Praça Frei Caetano Brandão — Cidade Velha, Belém',
        description:
            'Igreja matriz da Arquidiocese de Belém, local de saída da Trasladação. Uma das mais antigas igrejas da cidade.',
        latitude: -1.4524,
        longitude: -48.5023,
      ),
      PlaceModel(
        id: 'p3',
        name: 'Ponto de Hidratação — Largo de Nazaré',
        category: AppConstants.categoryHydration,
        address: 'Av. Nazaré, altura da Basílica — Nazaré, Belém',
        description:
            'Distribuição gratuita de água e soro oral para peregrinos durante a procissão. Operado pela Prefeitura de Belém e voluntários.',
        latitude: -1.4565,
        longitude: -48.5055,
      ),
      PlaceModel(
        id: 'p4',
        name: 'Ponto de Hidratação — Av. Generalíssimo',
        category: AppConstants.categoryHydration,
        address: 'Av. Generalíssimo Deodoro — Batista Campos, Belém',
        description:
            'Posto de hidratação com água, isotônicos e atendimento de primeiros socorros ao longo do percurso do Círio.',
        latitude: -1.4490,
        longitude: -48.4990,
      ),
      PlaceModel(
        id: 'p5',
        name: 'Mercado Ver-o-Peso',
        category: AppConstants.categoryFood,
        address: 'Beira do Rio, Campina — Belém',
        description:
            'Maior feira ao ar livre da América Latina. Excelente para experimentar culinária paraense: açaí, tacacá, maniçoba e caruru.',
        latitude: -1.4507,
        longitude: -48.5014,
      ),
      PlaceModel(
        id: 'p6',
        name: 'Hospital Metropolitano de Urgência',
        category: AppConstants.categoryHealth,
        address: 'Rod. BR-316, km 1 — Ananindeua, Belém',
        description:
            'Referência para atendimentos de urgência durante o período do Círio. Postos de atendimento avançados são montados ao longo do percurso.',
        latitude: -1.3790,
        longitude: -48.4170,
      ),
      PlaceModel(
        id: 'p7',
        name: 'Estação das Docas',
        category: AppConstants.categoryTourism,
        address: 'Bulevar Castilhos França — Campina, Belém',
        description:
            'Complexo turístico e gastronômico às margens do Rio Guamá. Ótimo ponto de descanso com restaurantes, lojas e vista para a baía do Guajará.',
        latitude: -1.4487,
        longitude: -48.5028,
      ),
      PlaceModel(
        id: 'p8',
        name: 'Banheiros Públicos — Praça da República',
        category: AppConstants.categoryRestroom,
        address: 'Praça da República — Campina, Belém',
        description:
            'Banheiros públicos disponíveis durante o período do Círio, com manutenção intensificada pela Prefeitura.',
        latitude: -1.4472,
        longitude: -48.4956,
      ),
      PlaceModel(
        id: 'p9',
        name: 'Mangal das Garças',
        category: AppConstants.categoryTourism,
        address: 'Passage Carneiro — Cidade Velha, Belém',
        description:
            'Parque ecológico à beira-rio com orquidário, borboletário e restaurante panorâmico. Ponto turístico imperdível em Belém.',
        latitude: -1.4562,
        longitude: -48.5067,
      ),
    ];
  }
}
