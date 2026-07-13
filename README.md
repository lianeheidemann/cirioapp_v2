<div align="center">

**English** · [Português](README.pt-BR.md)

<img width="120" src="assets/icon/icon.png" alt="CírioApp icon" />

# CírioApp

An information and assistance app for the Círio of Nazaré and the city of Belém, Pará.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)

</div>

![CírioApp interface](assets/images/interface_v3.png)

## About the project

CírioApp brings together essential information for residents, visitors, and
pilgrims during the Círio of Nazaré. The application provides event schedules,
useful locations, an interactive map, editorial news, push notifications,
favorites, and an AI assistant grounded in the app's own content.

The project is currently focused on Android and supports Portuguese and English.
Core content remains available offline, while Firebase and Gemini add connected
experiences when configured.

## Main features

- Event schedule with dates, times, categories, descriptions, and locations.
- Interactive OpenStreetMap with useful places and the user's current position.
- Editorial news synchronized in real time through Cloud Firestore.
- Push notifications through Firebase Cloud Messaging (FCM).
- Local notification history with deduplication and a 100-item limit.
- Favorites persisted on the device.
- AI assistant with local semantic retrieval, top-5 context, and response cache.
- Portuguese and English interface.
- Bundled news fallback when Firebase is unavailable.

## Technology stack

| Area | Technology |
|---|---|
| Application | Flutter and Dart |
| Target platform | Android |
| State management | Provider and ChangeNotifier |
| Remote data | Firebase Cloud Firestore |
| Notifications | Firebase Cloud Messaging |
| Local persistence | Shared Preferences |
| Maps | Flutter Map and OpenStreetMap |
| Device location | Geolocator |
| AI | Gemini API, embeddings, and cosine similarity in Dart |
| Localization | Flutter Localizations |
| Tests | Flutter Test |

## Architecture

The codebase is organized by feature and uses a layered data flow:

```text
lib/
├── core/          # configuration, theme, Firebase, and localization
├── data/
│   ├── local/     # on-device persistence
│   ├── models/    # domain models
│   ├── repositories/
│   └── services/  # Firestore, FCM, Gemini, and bundled sources
├── features/      # screens and providers grouped by feature
└── shared/        # reusable UI components
```

```text
News:         Firestore → Service → Repository → Provider → UI
Notifications: FCM → Service → Local storage → Provider → UI
AI assistant: Question → Embedding → Semantic cache → Top-5 → Gemini → Cache
```

This structure keeps platform integrations isolated from presentation code and
allows providers, persistence, and domain mapping to be tested independently.

## Requirements

- Flutter compatible with Dart 3.6 or newer.
- Android Studio and an Android SDK, or a configured physical device.
- A Firebase project for remote news and push notifications.
- A Gemini API key only when the AI assistant is enabled.
- Firebase CLI and FlutterFire CLI for Firebase reconfiguration or deployment.

## Getting started

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd cirioapp_v2
cp .env.example .env
flutter pub get
flutter run
```

On PowerShell, copy the environment template with:

```powershell
Copy-Item .env.example .env
```

Without a Gemini key, only the assistant is unavailable. If Firebase cannot be
initialized, the app continues to use bundled news and clearly indicates that
push notifications are not configured.

## Environment configuration

For local development, set the Gemini key in `.env`:

```env
GEMINI_API_KEY=your_key
```

For builds, prefer a compile-time definition:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_key
flutter build apk --dart-define=GEMINI_API_KEY=your_key
```

> Mobile application secrets can be extracted from a distributed APK. In
> production, proxy model requests through an authenticated backend, apply
> quotas, and keep provider credentials on the server.

## Firebase setup

The Android package is `com.lianeheidemann.cirioapp`. The Firebase Android app,
`google-services.json`, and FlutterFire options must all use this same package.
Changing the package after publication creates a new Android and Firebase app
identity.

To connect another Firebase project:

```bash
firebase login
flutterfire configure
firebase use --add
firebase deploy --only firestore
```

`flutterfire configure` generates `lib/firebase_options.dart` and configures the
Android integration. Firebase client configuration is not an administrative
secret, but service-account credentials and server keys must never be committed.

### Firestore news

The app listens to the `news` collection, selects documents where
`isPublished == true`, and orders them by `publishedAt` from newest to oldest.
Versioned rules allow public reads only for published content and block client
writes. News must be managed through the Firebase Console or a protected admin
backend.

See [docs/firestore_news.md](docs/firestore_news.md) for the schema, index,
security rules, and publishing workflow.

### Cloud Messaging notifications

Users enable notifications from the **Notifications** page. Once permission is
granted, the device subscribes to the `cirio_updates` topic. The app handles:

- messages received while the app is open;
- messages delivered while it is in the background;
- notifications that open the app from background or terminated state;
- notification payloads and data payloads containing `title` and `body`.

For broad Círio alerts, send a campaign from Firebase Console or target the
`cirio_updates` topic from a trusted backend using the Firebase Admin SDK. Do
not send FCM messages directly from the mobile client.

On Android 13 or newer, the user must grant the system notification permission.
If permission is denied, it can also be changed later in Android app settings.

## Location and privacy

When the map opens, the app explains why location is useful before requesting
the Android system permission. Access is limited to while the app is in use; no
background location permission is requested. The coordinates are used only to
center the map and display the current-position marker—they are not persisted or
sent to a server.

If location services are disabled or permission is permanently denied, the map
remains usable and offers a shortcut to the appropriate Android settings.

## AI assistant and embeddings

Events, locations, and FAQs are embedded offline and stored in
`assets/embeddings.json`. At runtime, only the user's question is embedded. The
app calculates cosine similarity locally, selects the five most relevant items,
and sends that context to Gemini. Semantically equivalent answers can be reused
from the local cache.

Regenerate the embedding asset whenever the public corpus changes:

```bash
dart run tool/generate_embeddings.dart
```

The generator reads `GEMINI_API_KEY` and, optionally,
`GEMINI_EMBEDDING_MODEL` from the environment or `.env`.

## Quality checks

```bash
dart analyze
flutter test
flutter build apk --debug
```

The current suite covers providers, local persistence, favorites, widgets,
Firestore mapping, semantic retrieval, response caching, embeddings, and the
notification history. All checks should pass before a release build.

## Useful project files

| File | Purpose |
|---|---|
| `lib/main.dart` | Application bootstrap and provider registration |
| `lib/core/firebase/firebase_bootstrap.dart` | Fault-tolerant Firebase startup |
| `lib/data/services/firestore_news_service.dart` | Real-time news integration |
| `lib/data/services/firebase_notifications_service.dart` | FCM lifecycle handling |
| `lib/features/notifications/` | Notification state and user interface |
| `firestore.rules` | Firestore access policy |
| `firestore.indexes.json` | Required Firestore indexes |
| `docs/firestore_news.md` | News collection documentation |

## Interface

<img src="assets/gif/interface_3.gif" alt="CírioApp demonstration" width="300" />
