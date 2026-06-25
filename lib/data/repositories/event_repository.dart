import '../models/event_model.dart';
import '../services/event_service.dart';

/// Repositório de eventos.
///
/// Abstrai a fonte de dados (mock vs. API futura) para o [EventsProvider].
class EventRepository {
  final EventService _service = EventService();

  Future<List<EventModel>> getEvents() => _service.fetchEvents();
}
