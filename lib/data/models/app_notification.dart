class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final Map<String, String> data;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.data = const {},
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        receivedAt: receivedAt,
        data: data,
        isRead: isRead ?? this.isRead,
      );

  Map<String, Object> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'receivedAt': receivedAt.toIso8601String(),
        'data': data,
        'isRead': isRead,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      receivedAt: DateTime.tryParse(json['receivedAt'] as String? ?? '') ??
          DateTime.now(),
      data: rawData is Map
          ? rawData.map((key, value) => MapEntry('$key', '$value'))
          : const {},
      // Notificações persistidas antes desse campo existir não têm a chave
      // no JSON — tratamos como já lidas para não gerar bolinha retroativa.
      isRead: json['isRead'] as bool? ?? true,
    );
  }
}
