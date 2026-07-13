class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final Map<String, String> data;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.data = const {},
  });

  Map<String, Object> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'receivedAt': receivedAt.toIso8601String(),
        'data': data,
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
    );
  }
}
