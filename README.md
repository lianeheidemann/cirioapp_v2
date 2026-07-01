<h1 align="center">CírioApp</h1>

<p align="center">
  <img width="20%" src="https://github.com/user-attachments/assets/4ea98343-89ab-478d-b472-3c6e8fa95aa9" />
</p>

<p align="center">
  <strong>App informativo sobre o Círio de Nazaré — Belém do Pará</strong>
  <br>
  A maior procissão católica do Brasil, na palma da sua mão.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.16+-02569B?style=flat&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/Platform-Android-brightgreen" alt="Platform">
</p>

---

## 📋 Sobre

O **CírioApp** é um aplicativo mobile desenvolvido em Flutter que reúne informações essenciais sobre o Círio de Nazaré, realizado anualmente em Belém do Pará. O app oferece:

- **Programação completa** dos eventos da quadra nazarena
- **Mapa interativo** com pontos de interesse (igrejas, hidratação, alimentação, saúde)
- **Notícias** sobre a festa religiosa
- **Favoritos** para salvar eventos, locais e notícias
- **Persistência local** dos favoritos entre sessões

---

## ✨ Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| 🏠 **Tela Inicial** | Acesso rápido a todas as seções com design hero |
| 📅 **Eventos** | Lista completa dos eventos do Círio com data, horário e local |
| 🗺️ **Mapa** | OpenStreetMap com marcadores categorizados (igrejas, hidratação, alimentação, saúde, banheiros, turismo) |
| 📰 **Notícias** | Feed de notícias com imagens e conteúdo completo |
| ⭐ **Favoritos** | Sistema de favoritos sincronizado entre eventos, locais e notícias |
| 🔍 **Filtros** | Filtro de pontos de interesse por categoria |
| 💾 **Persistência** | Favoritos salvos localmente via `shared_preferences` |

---

## 🏗️ Arquitetura

O projeto segue uma arquitetura em **camadas separadas por responsabilidade**, sem over-engineering:

```
lib/
├── main.dart                  # Entry point + MultiProvider setup
├── app.dart                   # MaterialApp + tema
├── core/                      # Recursos compartilhados
│   ├── constants/             # Constantes do app
│   └── theme/                 # Tema e paleta de cores
├── data/                      # Camada de dados
│   ├── models/                # Modelos (Event, Place, News)
│   ├── services/              # Serviços mockados (substituir por API futuramente)
│   ├── repositories/          # Repositórios (abstração dos serviços)
│   └── local/                 # Persistência local (favoritos)
├── features/                  # Features autocontidas
│   ├── home/                  # Tela inicial
│   ├── events/                # Eventos (provider + screens)
│   ├── places/                # Pontos de interesse (provider + screens)
│   ├── map/                   # Mapa interativo (provider + screen)
│   ├── news/                  # Notícias (provider + screens)
│   └── favorites/             # Favoritos (provider + screen)
└── shared/                    # Widgets reutilizáveis
    └── widgets/               # AppBar, FavoriteButton, EmptyState
```

**Gerenciamento de estado:** `ChangeNotifier` + `Provider` — simples, nativo do Flutter.

**Fluxo de dados:**

```
Service (mock) → Repository → Provider (ChangeNotifier) → Screen (Consumer)
                                   ↕
                         FavoritesProvider ← FavoritesLocalStorage
```

---

## 🛠️ Tecnologias

| Tecnologia | Versão | Finalidade |
|---|---|---|
| [Flutter](https://flutter.dev/) | 3.16+ | Framework cross-platform |
| [Dart](https://dart.dev/) | 3.0+ | Linguagem de programação |
| [Provider](https://pub.dev/packages/provider) | ^6.1.2 | Gerenciamento de estado |
| [flutter_map](https://pub.dev/packages/flutter_map) | ^6.1.0 | Mapa OpenStreetMap |
| [latlong2](https://pub.dev/packages/latlong2) | ^0.9.1 | Coordenadas geográficas |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.2.3 | Persistência local |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | ^3.3.1 | Cache de imagens |
| [intl](https://pub.dev/packages/intl) | ^0.19.0 | Formatação de datas |

---

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK `>=3.0.0 <4.0.0`
- Dispositivo/emulador Android
- Conexão com internet (para tiles do mapa e imagens)

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/cirio_app.git
cd cirio_app

# 2. Instale as dependências
flutter pub get

# 3. Execute no dispositivo/emulador
flutter run

# (Opcional) Build release
flutter build apk --release
```

> **Nota:** O mapa usa tiles gratuitos do OpenStreetMap — nenhuma chave de API é necessária.

---

## 📁 Estrutura de Arquivos

```
lib/
├── main.dart                          
├── app.dart                           
├── core/
│   ├── theme/
│   │   └── app_theme.dart             
│   └── constants/
│       └── app_constants.dart
├── data/
│   ├── models/
│   │   ├── event_model.dart 
│   │   ├── place_model.dart
│   │   └── news_model.dart
│   ├── services/
│   │   ├── event_service.dart
│   │   ├── place_service.dart
│   │   └── news_service.dart
│   ├── repositories/
│   │   ├── event_repository.dart
│   │   ├── place_repository.dart
│   │   └── news_repository.dart
│   └── local/
│       └── favorites_local_storage.dart
├── features/
│   ├── home/
│   │   └── home_screen.dart           
│   ├── events/
│   │   ├── events_provider.dart       
│   │   ├── events_screen.dart         
│   │   └── event_detail_screen.dart   
│   ├── places/
│   │   ├── places_provider.dart       
│   │   ├── places_screen.dart         
│   │   └── place_detail_screen.dart
│   ├── map/
│   │   ├── map_provider.dart         
│   │   └── map_screen.dart
│   ├── news/
│   │   ├── news_provider.dart
│   │   ├── news_screen.dart
│   │   └── news_detail_screen.dart
│   └── favorites/
│       ├── favorites_provider.dart  
│       └── favorites_screen.dart 
└── shared/
    └── widgets/
        ├── cirio_app_bar.dart
        ├── favorite_button.dart
        └── empty_state_widget.dart
```

---

## 🧪 Testes

```bash
flutter test
```

> Atualmente o projeto não possui testes automatizados.  
> **Contribuições são bem-vindas** para adicionar cobertura com `flutter_test` e `mockito`.

---

## 🚧 Melhorias Futuras

- [ ] **API real**: Substituir mocks por endpoints REST com `http` ou `dio`
- [ ] **Notificações push**: Lembretes de eventos com `firebase_messaging`
- [ ] **Modo offline**: Cache das listagens com `hive` ou `drift`
- [ ] **Compartilhamento**: Compartilhar evento/notícia via `share_plus`
- [ ] **Navegação GPS**: Abrir rotas no Google Maps com `url_launcher`
- [ ] **Internacionalização**: Suporte a inglês e espanhol com `flutter_localizations`
- [ ] **Dark mode**: Tema escuro com alternância manual
- [ ] **Acessibilidade**: Melhorar suporte a leitores de tela (`Semantics`)
- [ ] **CI/CD**: Pipeline com GitHub Actions para build e testes automáticos

---

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Siga os passos:

1. Fork o projeto
2. Crie sua branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'feat: add AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

---

## Ilustração 📱

<img width="4096" src="https://github.com/user-attachments/assets/f29362d6-449f-4676-8de8-f7d4f0e3139a" />

---

<p align="center">
  <strong>Círio de Nazaré — 2025</strong>
  <br>
  <em>Belém do Pará, Brasil</em>
</p>

