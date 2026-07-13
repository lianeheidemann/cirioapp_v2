<div align='center'>

<img width='15%' src='assets/icon/icon.png' alt='CírioApp Icon'/>

# CírioApp

Mobile app about the Círio de Nazaré, in Belém do Pará

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square)

</div>


<img src='assets/images/GridArt_20260713_051055219.png' />

## Features

- **Events:** schedule with dates, times, and locations.
- **Interactive map:** Círio route and points of interest on OpenStreetMap.
- **News:** informative content with local images.
- **Favorites:** events, locations, and news saved on the device.
- **AI Assistant:** contextualized answers about the Círio and Belém using the Gemini API.
- **Portuguese and English:** real-time language switching.

## Technologies

- Flutter and Dart
- Provider for state management
- Flutter Map and OpenStreetMap
- Shared Preferences for local persistence
- Flutter Localizations for internationalization
- Gemini API via HTTP

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

> Never commit the `.env` file or a real key to the repository.

## Architecture

The project uses a feature-based organization with layered separation:

- `features`: screens and providers for each feature.
- `data/services`: local data sources and external integrations.
- `data/repositories`: communication between services and application rules.
- `core`: theme, constants, and localization.
- `shared`: reusable UI components.

State is managed with `ChangeNotifier`, `Provider`, and `ChangeNotifierProxyProvider`.

## Tests

Tests cover providers, favorites persistence, and main widgets.

```bash
flutter test
```

## Interface

<img src='assets/gif/interface_3.gif' alt='CírioApp Interface' width='50%' />
