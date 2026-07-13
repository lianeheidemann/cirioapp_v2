import 'dart:convert';
import 'dart:io';

import 'package:cirio_app/core/constants/ai_faqs.dart';
import 'package:cirio_app/data/services/event_service.dart';
import 'package:cirio_app/data/services/news_service.dart';
import 'package:cirio_app/data/services/place_service.dart';
import 'package:http/http.dart' as http;

const _defaultModel = 'gemini-embedding-001';
// Reduz o tamanho do asset sem perder qualidade relevante para este corpus.
const _dimensions = 768;

/// Gera `assets/embeddings.json`; deve ser executado apenas no desenvolvimento.
///
/// A chave é lida localmente e nunca é gravada no JSON. O arquivo final contém
/// somente conteúdo público do app, metadados do modelo e vetores numéricos.
Future<void> main() async {
  final env = _readDotEnv(File('.env'));
  final apiKey =
      Platform.environment['GEMINI_API_KEY'] ?? env['GEMINI_API_KEY'];
  final model = Platform.environment['GEMINI_EMBEDDING_MODEL'] ??
      env['GEMINI_EMBEDDING_MODEL'] ??
      _defaultModel;
  if (apiKey == null || apiKey.trim().isEmpty) {
    stderr.writeln('Defina GEMINI_API_KEY no ambiente ou no arquivo .env.');
    exitCode = 2;
    return;
  }

  // Só substituímos o asset depois que todos os documentos foram processados.
  // Uma falha no meio, portanto, preserva o último corpus válido.
  final documents = await _buildDocuments();
  final client = http.Client();
  final output = <Map<String, dynamic>>[];
  try {
    for (var i = 0; i < documents.length; i++) {
      final document = documents[i];
      stdout.writeln('[${i + 1}/${documents.length}] ${document['title']}');
      final embedding = await _embedDocument(
        client: client,
        apiKey: apiKey,
        model: model,
        title: document['title']!,
        content: document['content']!,
      );
      output.add({...document, 'embedding': embedding});
    }
  } finally {
    client.close();
  }

  final asset = {
    'schemaVersion': 1,
    'model': model,
    'dimensions': _dimensions,
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'items': output,
  };
  await File('assets/embeddings.json').writeAsString(
    const JsonEncoder.withIndent('  ').convert(asset),
  );
  stdout.writeln('Asset gerado com ${output.length} itens.');
}

/// Normaliza as fontes públicas do app para um formato textual único.
Future<List<Map<String, String>>> _buildDocuments() async {
  final events = await EventService().fetchEvents();
  final places = await PlaceService().fetchPlaces();
  final news =
      (await LocalNewsService().fetchNews()).where((item) => item.isPublished);
  return [
    for (final event in events)
      {
        'id': event.id,
        'type': 'evento',
        'title': event.title,
        'content':
            '${event.title}. Categoria: ${event.category}. Data: ${event.date}, às ${event.time}. Local: ${event.location}. ${event.description}',
      },
    for (final place in places)
      {
        'id': place.id,
        'type': 'local',
        'title': place.name,
        'content':
            '${place.name}. Categoria: ${place.category}. Endereço: ${place.address}. ${place.description}',
      },
    for (final article in news)
      {
        'id': 'news-${article.id}',
        'type': 'notícia',
        'title': article.title,
        'content':
            'Notícia publicada em ${article.date}. ${article.title}. ${article.summary} ${article.content}',
      },
    for (final faq in aiFaqs)
      {
        'id': faq.id,
        'type': 'faq',
        'title': faq.question,
        'content': 'Pergunta frequente: ${faq.question}. ${faq.content}',
      },
  ];
}

/// Envia um documento por vez com o task type próprio para indexação.
///
/// A validação da dimensão impede publicar um asset cujo metadado não
/// corresponda aos vetores efetivamente retornados pela API.
Future<List<double>> _embedDocument(
    {required http.Client client,
    required String apiKey,
    required String model,
    required String title,
    required String content}) async {
  final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:embedContent');
  final response = await client
      .post(
        uri,
        headers: {'Content-Type': 'application/json', 'x-goog-api-key': apiKey},
        body: jsonEncode({
          'content': {
            'parts': [
              {'text': content},
            ],
          },
          'taskType': 'RETRIEVAL_DOCUMENT',
          'title': title,
          'outputDimensionality': _dimensions,
        }),
      )
      .timeout(const Duration(seconds: 30));
  if (response.statusCode != 200) {
    throw HttpException(
        'Falha ao gerar embedding (${response.statusCode}): ${response.body}');
  }
  final json =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  final embedding =
      ((json['embedding'] as Map<String, dynamic>)['values'] as List)
          .map((value) => (value as num).toDouble())
          .toList(growable: false);
  if (embedding.length != _dimensions) {
    throw const FormatException(
        'A API retornou um embedding com dimensão incompatível.');
  }
  return embedding;
}

/// Leitor mínimo de `.env`, suficiente para o script sem inicializar o Flutter.
Map<String, String> _readDotEnv(File file) {
  if (!file.existsSync()) return {};
  final values = <String, String>{};
  for (final rawLine in file.readAsLinesSync()) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final separator = line.indexOf('=');
    if (separator <= 0) continue;
    final key = line.substring(0, separator).trim();
    var value = line.substring(separator + 1).trim();
    if (value.length >= 2) {
      final quote = value.codeUnitAt(0);
      final isQuote = quote == 34 || quote == 39;
      if (isQuote && value.codeUnitAt(value.length - 1) == quote) {
        value = value.substring(1, value.length - 1);
      }
    }
    values[key] = value;
  }
  return values;
}
