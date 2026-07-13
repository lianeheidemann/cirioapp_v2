<div align='center'>

**English** · [Português](README.pt-BR.md)

<img width='15%' src='assets/icon/icon.png' alt='CírioApp Icon'/>

# CírioApp

Mobile app about the Círio de Nazaré, in Belém do Pará

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square)

</div>


<img src='assets/images/interface_v3.png' />

## Features

- **Events:** schedule with dates, times, and locations.
- **Interactive map:** Círio route and points of interest on OpenStreetMap.
- **News:** informative content with local images.
- **Favorites:** events, locations, and news saved on the device.
- **Local-RAG AI Assistant:** contextual answers using semantic search, top-5 retrieval, and a similar-question cache.
- **Portuguese and English:** real-time language switching.

## Technologies

- Flutter and Dart
- Provider for state management
- Flutter Map and OpenStreetMap
- Shared Preferences for local persistence
- Flutter Localizations for internationalization
- Gemini API via HTTP
- Local embeddings and pure-Dart cosine similarity

## How to run

Have the Flutter SDK installed and an Android device or emulator configured.

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd cirioapp_v2
flutter pub get
flutter run
```

The map and AI assistant require an internet connection. The remaining content is available locally.

## AI Assistant

Configuring the Gemini API is optional. Without a key, only the assistant will be unavailable.

For local development, copy `.env.example` to `.env` and provide the key:

```env
GEMINI_API_KEY=your_key
```

You can also provide it at runtime:

```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY
```

> Never commit `.env` or a real key. A key distributed inside an APK can be
> extracted; direct client-side configuration is suitable only for development
> and demos. In production, use an authenticated, rate-limited backend/proxy and
> keep the key on the server.

### Semantic search and embeddings

The assistant uses a lightweight RAG implementation without an external vector
database:

1. Events, places, and FAQs are embedded offline on the developer machine.
2. The corpus and vectors are written to `assets/embeddings.json`.
3. Each question makes exactly one embedding request.
4. The app compares the question with the local corpus using pure-Dart cosine similarity.
5. Only the five closest items are added to the prompt.
6. On a cache miss, the app calls `generateContent`.
7. A successful answer is stored locally for semantically similar questions.

The full corpus is never sent while answering a question. Generation receives
only the instructions, user question, and retrieved context.

### Generate or update the asset

Regenerate the asset whenever the local knowledge changes:

```bash
dart run tool/generate_embeddings.dart
```

The script reads `GEMINI_API_KEY` from the environment or `.env` and writes
`assets/embeddings.json`. It defaults to `gemini-embedding-001`, the current
successor to the deprecated `text-embedding-004`. Vectors use 768 dimensions to
keep the bundled asset compact.

To select another compatible model in PowerShell:

```powershell
$env:GEMINI_EMBEDDING_MODEL=model-name
dart run tool/generate_embeddings.dart
```

In Bash:

```bash
GEMINI_EMBEDDING_MODEL=model-name dart run tool/generate_embeddings.dart
```

The generator replaces the asset only after processing every document and
validates the dimension returned by the API. Model and dimension metadata are
stored in the JSON so runtime queries always use the same vector space.

### Semantic cache

- Persisted on-device with Shared Preferences.
- Limited to the 50 most recent answers.
- Reuses an answer at a similarity of `0.94` or higher.
- Keeps entries separate by language and embedding model.
- Cache misses continue through normal retrieval and generation.

## Architecture

The project uses a feature-based organization with layered separation:

- `features`: screens and providers for each feature.
- `data/services`: local data sources and external integrations.
- `data/repositories`: communication between services and application rules.
- `core`: theme, constants, and localization.
- `shared`: reusable UI components.

State is managed with `ChangeNotifier`, `Provider`, and `ChangeNotifierProxyProvider`.

Main assistant files:

- `tool/generate_embeddings.dart`: builds the vector corpus offline.
- `assets/embeddings.json`: corpus bundled with the application.
- `lib/data/services/gemini_service.dart`: embedding and generation requests.
- `lib/data/services/semantic_search_service.dart`: asset validation, cosine similarity, and top-5 ranking.
- `lib/data/local/ai_response_cache.dart`: persistent semantic response cache.
- `lib/data/repositories/ai_assistant_repository.dart`: orchestrates cache, retrieval, and prompt construction.
- `lib/core/constants/ai_faqs.dart`: single FAQ source for the UI and corpus.

## Tests

Tests cover providers, favorites persistence, widgets, cosine similarity, the
real embedding asset, top-5 ranking, and cache language isolation.

```bash
dart analyze
flutter test
```

## Interface

<img src='assets/gif/interface_3.gif' alt='CírioApp Interface' width='50%' />
