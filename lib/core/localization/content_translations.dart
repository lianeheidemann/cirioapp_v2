import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';
import '../../data/models/news_model.dart';
import '../../data/models/place_model.dart';
import 'app_language.dart';

abstract final class ContentTranslations {
  static bool _english(BuildContext context) => tr(context, 'pt', 'en') == 'en';

  static String news(BuildContext context, NewsModel item, String field) {
    if (!_english(context)) return _newsFallback(item, field);
    return _news[item.id]?[field] ?? _newsFallback(item, field);
  }

  static String _newsFallback(NewsModel item, String field) => switch (field) {
        'title' => item.title,
        'date' => item.date,
        'summary' => item.summary,
        'content' => item.content,
        _ => '',
      };

  static const _news = <String, Map<String, String>>{
    'n1': {
      'title': 'Círio 2026 expects to welcome 2.5 million faithful',
      'date': 'September 28, 2026',
      'summary':
          'Organizers expect record attendance at Brazil’s largest Catholic procession.',
      'content':
          'The Archdiocese of Belém announced an estimate of 2.5 million participants for the 2026 Círio of Nazaré. Planning includes reinforced healthcare services, with 120 medical stations along the 3.6 km route. The Municipal Guard and Military Police will deploy around 3,000 officers to ensure pilgrims’ safety. The mayor of Belém confirmed an investment of 8 million Brazilian reais in infrastructure, including new hydration points and portable restrooms.',
    },
    'n2': {
      'title': 'The Círio rope: a tradition uniting pilgrims for centuries',
      'date': 'October 5, 2026',
      'summary':
          'Learn the meaning and history of the famous rope that guides the Círio procession.',
      'content':
          'The Círio rope is much more than an organizational element of the procession. About 400 meters long, it represents the spiritual bond between the faithful and Our Lady of Nazaré. The tradition of pulling the rope began in the 19th century as a way for devotees to remain close to the carriage carrying the image of the saint. Today, families, associations, and communities seek the privilege of holding the rope. It is renewed every year with new fibers while retaining pieces of the former rope as relics.',
    },
    'n3': {
      'title': 'Pará cuisine takes over Círio: what to eat in Belém',
      'date': 'October 8, 2026',
      'summary':
          'From maniçoba to duck in tucupi, local cuisine is an essential part of the celebration.',
      'content':
          'Pará cuisine takes center stage during the Círio season. The traditional Círio lunch, held in family homes on the Sunday of the procession, brings together dishes such as maniçoba, duck in tucupi, caruru, and vatapá. Ver-o-Peso, Latin America’s largest open-air market, offers some of the best food experiences for visitors. Pará-style açaí, served thick and without added sugar, is a must. Estação das Docas offers riverside restaurants and sophisticated regional menus.',
    },
    'n4': {
      'title': 'Círio cultural program features over 50 free events',
      'date': 'October 1, 2026',
      'summary':
          'Concerts, exhibitions, and cultural activities enliven Belém throughout October.',
      'content':
          'The City of Belém announced the 2026 Círio cultural program, featuring more than 50 free events throughout the city. Highlights include Expo Círio at the Hangar Convention Center, with regional crafts and cuisine; the Sacred Music Festival at the Basilica Sanctuary; and national concerts at Largo de Nazaré on the eve of the procession. Belém’s theaters and museums will also offer special programming and free admission during the Nazaré festivities.',
    },
    'n5': {
      'title': 'How to prepare for a safe Círio experience',
      'date': 'October 10, 2026',
      'summary':
          'Essential advice for those joining the procession for the first time.',
      'content':
          'Taking part in Círio requires physical and logistical preparation. Experts recommend wearing light clothing and comfortable shoes, carrying water and sunscreen, avoiding the center of the route if you experience claustrophobia, agreeing on a meeting point with your group, keeping documents and your phone in an inside pocket, and arriving early. The route takes about four hours and the morning sun can be intense. Older adults and young children should watch from fixed points along the route.',
    },
  };
  static String event(BuildContext context, EventModel item, String field) {
    if (!_english(context)) return _eventFallback(item, field);
    return _events[item.id]?[field] ?? _eventFallback(item, field);
  }

  static String place(BuildContext context, PlaceModel item, String field) {
    if (!_english(context)) return _placeFallback(item, field);
    return _places[item.id]?[field] ?? _placeFallback(item, field);
  }

  static String category(BuildContext context, String value) {
    if (!_english(context)) return value;
    return const {
          'Igreja': 'Church',
          'Hidratação': 'Hydration',
          'Alimentação': 'Food',
          'Saúde': 'Health',
          'Banheiro': 'Restroom',
          'Turismo': 'Tourism',
          'Procissão': 'Procession',
          'Missa': 'Mass',
          'Cultural': 'Cultural',
          'Todos': 'All',
        }[value] ??
        value;
  }

  static String _eventFallback(EventModel item, String field) =>
      switch (field) {
        'title' => item.title,
        'date' => item.date,
        'time' => item.time,
        'location' => item.location,
        'category' => item.category,
        'description' => item.description,
        _ => '',
      };

  static String _placeFallback(PlaceModel item, String field) =>
      switch (field) {
        'name' => item.name,
        'category' => item.category,
        'address' => item.address,
        'description' => item.description,
        _ => '',
      };

  static const _events = <String, Map<String, String>>{
    'e1': {
      'title': 'Transfer of the Image',
      'date': 'October 10, 2026',
      'location': 'Basilica Sanctuary of Nazaré',
      'category': 'Procession',
      'description':
          'A procession that transfers the image of Our Lady of Nazaré from the Cathedral of Sé to the Basilica Sanctuary, officially opening the Círio festivities.'
    },
    'e2': {
      'title': 'Círio of Nazaré',
      'date': 'October 11, 2026',
      'location': 'Departure: Gentil Bittencourt School',
      'category': 'Procession',
      'description':
          'Brazil’s largest procession, with more than two million faithful accompanying the image of Our Lady of Nazaré through the streets of Belém, from Gentil Bittencourt School to the Basilica Sanctuary.'
    },
    'e3': {
      'title': 'Opening Mass of the Nazaré Festivities',
      'date': 'October 1, 2026',
      'location': 'Basilica Sanctuary of Nazaré',
      'category': 'Mass',
      'description':
          'A solemn Mass opening the month of Círio, celebrated by the Archbishop of Belém and broadcast live by TV Nazaré.'
    },
    'e4': {
      'title': 'Chiquita Festival',
      'date': 'October 10, 2026',
      'location': 'Largo de Nazaré',
      'category': 'Cultural',
      'description':
          'A popular cultural celebration held on the eve of Círio, bringing together music groups, regional food stalls, and concerts around the Basilica.'
    },
    'e5': {
      'title': 'Recírio',
      'date': 'October 18, 2026',
      'location': 'Basilica Sanctuary of Nazaré',
      'category': 'Procession',
      'description':
          'The return procession of the image, closing the 2026 Círio cycle. The route runs from the Basilica to Ver-o-Peso through Belém’s historic center.'
    },
    'e6': {
      'title': 'Children’s Mass',
      'date': 'October 5, 2026',
      'location': 'Basilica Sanctuary of Nazaré',
      'category': 'Mass',
      'description':
          'A special celebration for children, with accessible language, performances, and active participation by young members of the faithful.'
    },
  };

  static const _places = <String, Map<String, String>>{
    'p1': {
      'name': 'Basilica Sanctuary of Nazaré',
      'category': 'Church',
      'address': 'Justo Chermont Square — Nazaré, Belém',
      'description':
          'The main arrival point of Círio, where the image of Our Lady of Nazaré remains on display throughout October.'
    },
    'p2': {
      'name': 'Cathedral of Sé',
      'category': 'Church',
      'address': 'Frei Caetano Brandão Square — Old Town, Belém',
      'description':
          'The main church of the Archdiocese of Belém and the starting point of the Transfer procession. It is one of the city’s oldest churches.'
    },
    'p3': {
      'name': 'Hydration Point — Largo de Nazaré',
      'category': 'Hydration',
      'address': 'Nazaré Avenue, by the Basilica — Nazaré, Belém',
      'description':
          'Free water and oral rehydration solution for pilgrims during the procession, operated by the City of Belém and volunteers.'
    },
    'p4': {
      'name': 'Hydration Point — Generalíssimo Avenue',
      'category': 'Hydration',
      'address': 'Generalíssimo Deodoro Avenue — Batista Campos, Belém',
      'description':
          'A hydration station offering water, sports drinks, and first aid along the Círio route.'
    },
    'p5': {
      'name': 'Ver-o-Peso Market',
      'category': 'Food',
      'address': 'Riverside, Campina — Belém',
      'description':
          'Latin America’s largest open-air market and an excellent place to try Pará cuisine, including açaí, tacacá, maniçoba, and caruru.'
    },
    'p6': {
      'name': 'Metropolitan Emergency Hospital',
      'category': 'Health',
      'address': 'BR-316 Highway, km 1 — Ananindeua, Belém',
      'description':
          'A reference hospital for emergency care during Círio. Advanced medical stations are also set up along the route.'
    },
    'p7': {
      'name': 'Estação das Docas',
      'category': 'Tourism',
      'address': 'Castilhos França Boulevard — Campina, Belém',
      'description':
          'A tourist and dining complex on the Guamá River, with restaurants, shops, and views over Guajará Bay.'
    },
    'p8': {
      'name': 'Public Restrooms — Republic Square',
      'category': 'Restroom',
      'address': 'Republic Square — Campina, Belém',
      'description':
          'Public restrooms available during Círio, with enhanced maintenance by the city government.'
    },
    'p9': {
      'name': 'Mangal das Garças',
      'category': 'Tourism',
      'address': 'Carneiro Passage — Old Town, Belém',
      'description':
          'A riverside ecological park with an orchid house, butterfly garden, and panoramic restaurant. A must-see attraction in Belém.'
    },
  };
}
