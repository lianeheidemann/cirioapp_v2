/// Modelo que representa um evento da programação do Círio.
///
/// Inclui data, horário, local e categoria. O campo [isFavorite] é
/// atualizado em tempo real pelo [EventsProvider] ao sincronizar com
/// o [FavoritesProvider].
class EventModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String category;
  bool isFavorite;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.category,
    this.isFavorite = false,
  });

  /// Retorna uma cópia com [isFavorite] opcionalmente alterado.
  EventModel copyWith({bool? isFavorite}) {
    return EventModel(
      id: id,
      title: title,
      date: date,
      time: time,
      location: location,
      description: description,
      category: category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
