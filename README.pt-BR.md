<div align="center">

[English](README.md) · **Português**

<img width="110" src="assets/icon/icon.png" alt="Ícone do CírioApp" />

# CírioApp

Informação e assistência para o Círio de Nazaré em Belém do Pará.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)

</div>

![Interface do CírioApp](assets/images/interface_v3.png)

## Visão geral

O CírioApp ajuda moradores, visitantes e peregrinos a acessar informações
confiáveis sobre o Círio de Nazaré. O aplicativo reúne programação, locais
úteis, notícias, notificações e um assistente de IA em uma experiência Android
bilíngue.

## Funcionalidades

- Programação de eventos e informações sobre as procissões.
- OpenStreetMap com pontos de interesse e localização atual do usuário.
- Notícias editoriais em tempo real pelo Cloud Firestore.
- Notificações push pelo Firebase Cloud Messaging.
- Favoritos e histórico de notificações armazenados no dispositivo.
- Assistente de IA com busca semântica local e Gemini.
- Interface em português e inglês.

## Tecnologias

| Área | Stack |
|---|---|
| Aplicativo | Flutter, Dart e Provider |
| Serviços remotos | Firebase Firestore e Cloud Messaging |
| Mapas e localização | Flutter Map, OpenStreetMap e Geolocator |
| Persistência local | Shared Preferences |
| IA | Gemini API e embeddings locais |
| Testes | Flutter Test |

## Estrutura do projeto

```text
lib/
├── core/       # configuração, tema, Firebase e localização
├── data/       # modelos, repositórios, serviços e persistência
├── features/   # telas e providers por funcionalidade
└── shared/     # componentes reutilizáveis de interface
```

## Executar localmente

Requisitos: Flutter com Dart 3.6+, Android SDK e dispositivo ou emulador
configurado.

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd cirioapp_v2
cp .env.example .env
flutter pub get
flutter run
```

No PowerShell, use `Copy-Item .env.example .env` no lugar de `cp`.

## Configuração

### Firebase

O aplicativo Android utiliza o pacote `com.lianeheidemann.cirioapp`. Para
conectar outro projeto Firebase, execute `flutterfire configure` e publique as
regras e os índices versionados do Firestore.

As notícias são lidas da coleção `news`. As notificações utilizam o tópico FCM
`cirio_updates`. Consulte [docs/firestore_news.md](docs/firestore_news.md) para
ver o esquema das notícias e o fluxo de publicação.

### Gemini

Adicione uma chave de desenvolvimento ao arquivo `.env`:

```env
GEMINI_API_KEY=sua_chave
```

Em produção, mantenha as credenciais do provedor em um backend protegido, sem
incluir segredos no APK.

## Qualidade

```bash
dart analyze
flutter test
flutter build apk --debug
```
