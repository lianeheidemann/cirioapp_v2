<div align="center">

<img width="15%" src="assets/icon/icon.png"/>

# CírioApp
Aplicativo mobile informativo sobre o Círio de Nazaré — Belém do Pará. A maior procissão católica do Brasil, na palma da sua mão.

![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=flat-square)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Android-brightgreen?style=flat-square)

</div>

---

## Visão Geral

CírioApp é um aplicativo mobile desenvolvido em Flutter que centraliza informações sobre o Círio de Nazaré: programação de eventos, mapa interativo, notícias, sistema de favoritos e um assistente de IA (Gemini) para tirar dúvidas sobre a festividade. O app está disponível em Português e Inglês.

---

## Funcionalidades

- **Eventos** — Calendário completo com datas, horários e locais
- **Mapa Interativo** — OpenStreetMap com o trajeto do Círio e pontos de interesse categorizados (igrejas, hidratação, alimentação, saúde, banheiros, turismo)
- **Notícias** — Feed com conteúdo sobre o Círio
- **Favoritos** — Sistema sincronizado para eventos, locais e notícias, persistido localmente
- **Assistente IA** — Chat com IA generativa (Google Gemini) especializado em dúvidas sobre o Círio e Belém
- **Português / Inglês** — Alternância de idioma em tempo real, inclusive no conteúdo do assistente e dos dados mockados

---

## Tecnologias

| Tecnologia | Versão | Uso |
|---|---|---|
| Flutter | 3.16+ | Framework de UI |
| Dart | 3.0+ | Linguagem |
| provider | ^6.1.2 | Gerenciamento de estado |
| flutter_map | ^7.0.2 | Mapa interativo (OpenStreetMap) |
| latlong2 | ^0.9.1 | Coordenadas geográficas do mapa |
| shared_preferences | ^2.2.3 | Persistência local de favoritos e idioma |
| cached_network_image | ^3.3.1 | Cache de imagens das notícias |
| http | ^1.2.2 | Chamadas à Gemini API |
| flutter_dotenv | ^5.1.0 | Carregamento da chave da Gemini API via `.env` |
| flutter_lints | ^3.0.0 | Regras de lint (dev) |
| flutter_launcher_icons | ^0.13.1 | Geração do ícone do app (dev) |

---

## Como Executar

Pré-requisitos:
- Flutter SDK `>=3.0.0 <4.0.0`
- Android SDK 21+
- Conexão com internet (mapa, imagens das notícias e assistente de IA)

Passos:

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd cirioapp_v2
flutter pub get
flutter run
```

---

## Configurando o Assistente IA (Gemini API)

O assistente de IA usa a [Gemini API](https://ai.google.dev/) do Google. **Sem uma chave configurada, o restante do app funciona normalmente — apenas a tela "Assistente IA" fica indisponível**, exibindo uma mensagem explicando como configurá-la.

> ⚠️ **Nunca commite uma chave real de API.** O arquivo `.env` já está no `.gitignore` — mantenha-o assim. Se uma chave for exposta acidentalmente (em um commit, print, ou zip compartilhado), revogue-a imediatamente em [aistudio.google.com/apikey](https://aistudio.google.com/apikey) e gere uma nova.

Existem três formas de fornecer a chave, em ordem de prioridade (`GeminiConfig.apiKey`):

1. **Recomendado** — variável de ambiente do Dart, em tempo de build/execução:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
   flutter build apk --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
   ```

2. **Alternativa (dev local)** — copie `.env.example` para `.env` e preencha `GEMINI_API_KEY`:
   ```bash
   cp .env.example .env
   # edite .env e defina GEMINI_API_KEY=sua_chave
   ```
   O `.env` já é carregado automaticamente em `main.dart` via `flutter_dotenv` e está no `.gitignore` — nunca remova essa entrada.

3. **Apenas para testes locais rápidos** — preencha `GeminiConfig.fallbackApiKey` em `lib/core/constants/gemini_config.dart`. Nunca faça commit desse valor preenchido.

---

## Testes

O projeto tem testes unitários e de widget cobrindo persistência de favoritos, providers e a tela de Favoritos:

```bash
flutter test
```

---

## Estrutura de Arquivos

```
lib/
├── main.dart                                  # Ponto de entrada e injeção de providers
├── app.dart                                   # MaterialApp, tema e locale
├── core/
│   ├── constants/
│   │   ├── app_constants.dart                 # Categorias, chaves de favoritos, coordenadas
│   │   └── gemini_config.dart                 # Configuração/prioridade da chave da Gemini API
│   ├── localization/
│   │   ├── app_language.dart                  # LanguageProvider (pt/en) + helper tr()
│   │   └── content_translations.dart          # Traduções do conteúdo mockado (eventos, locais, notícias)
│   └── theme/
│       ├── app_theme.dart                     # ThemeData (Material 3)
│       ├── app_colors.dart
│       ├── app_radius.dart
│       ├── app_shadows.dart
│       └── app_spacing.dart
├── data/
│   ├── models/
│   │   ├── event_model.dart
│   │   ├── place_model.dart
│   │   └── news_model.dart
│   ├── services/                              # Fonte de dados (mock atual; substituir por API real)
│   │   ├── event_service.dart
│   │   ├── place_service.dart
│   │   ├── news_service.dart
│   │   └── gemini_service.dart                # Cliente HTTP da Gemini API
│   ├── repositories/                          # Abstração entre services e providers
│   │   ├── event_repository.dart
│   │   ├── place_repository.dart
│   │   ├── news_repository.dart
│   │   └── ai_assistant_repository.dart       # Monta o contexto e o prompt do assistente
│   └── local/
│       └── favorites_local_storage.dart       # Persistência de favoritos via SharedPreferences
├── features/
│   ├── home/home_screen.dart
│   ├── events/
│   │   ├── events_screen.dart
│   │   ├── event_detail_screen.dart
│   │   └── events_provider.dart
│   ├── places/
│   │   ├── places_screen.dart
│   │   ├── place_detail_screen.dart
│   │   └── places_provider.dart
│   ├── map/
│   │   ├── map_screen.dart
│   │   └── map_provider.dart
│   ├── news/
│   │   ├── news_screen.dart
│   │   ├── news_detail_screen.dart
│   │   └── news_provider.dart
│   ├── favorites/
│   │   ├── favorites_screen.dart
│   │   └── favorites_provider.dart
│   └── ai_assistant/
│       ├── ai_assistant_screen.dart
│       └── ai_assistant_provider.dart
└── shared/widgets/
    ├── cirio_app_bar.dart
    ├── favorite_button.dart
    ├── empty_state_widget.dart
    ├── app_loading.dart
    └── section_header.dart

test/
├── favorites_local_storage_test.dart
├── favorites_provider_test.dart
├── favorites_screen_test.dart
├── events_provider_test.dart
├── language_provider_test.dart
└── helpers/fake_services.dart
```

---

## Arquitetura

O app segue uma separação simples em camadas:

- **`data/services`** — fonte de dados (hoje, mocks com latência simulada; a Gemini API é a única integração HTTP real);
- **`data/repositories`** — abstraem a origem dos dados para os providers, facilitando trocar mock por API real no futuro;
- **`features/*/*_provider.dart`** — `ChangeNotifier`s que expõem estado para a UI via `provider`. Eventos, locais e notícias usam `ChangeNotifierProxyProvider` para reagir automaticamente a mudanças no `FavoritesProvider`;
- **`features/*/*_screen.dart`** — telas, consumindo os providers via `Consumer`/`context.watch`.

---

<img width="100%" src="https://github.com/user-attachments/assets/f29362d6-449f-4676-8de8-f7d4f0e3139a" alt="CírioApp Screenshots" />
