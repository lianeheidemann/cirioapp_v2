<div align="center">

**English** · [Português](README.pt-BR.md)

<img width="110" src="assets/icon/icon.png" alt="CírioApp icon" />

# CírioApp

Information and assistance for the Círio of Nazaré in Belém, Pará.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)

</div>

![CírioApp interface](assets/images/interface_v3.png)

## Overview

CírioApp helps residents, visitors, and pilgrims access reliable information
about the Círio of Nazaré. It combines event schedules, useful places, news,
notifications, and an AI assistant.

## Features

- Event schedule and procession information.
- OpenStreetMap with points of interest and the user's current location.
- Real-time editorial news from Cloud Firestore.
- Push notifications through Firebase Cloud Messaging.
- On-device favorites and notification history.
- AI assistant with local semantic retrieval and Gemini.
- Portuguese and English interface.

## Technology

| Area | Stack |
|---|---|
| App | Flutter, Dart, Provider |
| Backend services | Firebase Firestore and Cloud Messaging |
| Maps and location | Flutter Map, OpenStreetMap, Geolocator |
| Local storage | Shared Preferences |
| AI | Gemini API and local embeddings |
| Tests | Flutter Test |

## Project structure

```text
lib/
├── core/       # configuration, theme, Firebase, localization
├── data/       # models, repositories, services, local storage
├── features/   # screens and providers by feature
└── shared/     # reusable UI components
```

## Run locally

Requirements: Flutter with Dart 3.6+, Android SDK, and a configured device or
emulator.

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd cirioapp_v2
cp .env.example .env
flutter pub get
flutter run
```

On PowerShell, use `Copy-Item .env.example .env` instead of `cp`.

## Configuration

### Firebase

The Android app uses the package `com.lianeheidemann.cirioapp`. To connect a
different Firebase project, run `flutterfire configure` and deploy the versioned
Firestore rules and indexes.

News is read from the `news` collection. Notifications use the
`cirio_updates` FCM topic. See [docs/firestore_news.md](docs/firestore_news.md)
for the news schema and publishing workflow.

### Gemini

Add a development key to `.env`:

```env
GEMINI_API_KEY=your_key
```

For production, keep provider credentials in a protected backend instead of
shipping secrets in the APK.

## Quality checks

```bash
dart analyze
flutter test
flutter build apk --debug
```

## Ilustração 

![CírioApp interface](assets/gif/AppCirio_Gif.gif)
