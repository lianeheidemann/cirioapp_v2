<div align="center">

[English](README.md) · **Português**

<img width="120" src="assets/icon/icon.png" alt="Ícone do CírioApp" />

# CírioApp

Aplicativo de informação e assistência para o Círio de Nazaré e a cidade de Belém do Pará.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)

</div>

![Interface do CírioApp](assets/images/interface_v3.png)

## Sobre o projeto

O CírioApp reúne informações essenciais para moradores, visitantes e peregrinos
durante o Círio de Nazaré. O aplicativo oferece programação de eventos, locais
úteis, mapa interativo, notícias editoriais, notificações, favoritos e um
assistente de IA fundamentado no conteúdo do próprio app.

O projeto está direcionado atualmente ao Android e oferece interface em
português e inglês. Os conteúdos essenciais permanecem disponíveis localmente,
enquanto Firebase e Gemini adicionam recursos conectados quando configurados.

## Principais recursos

- Programação de eventos com datas, horários, categorias, descrições e locais.
- Mapa OpenStreetMap com locais úteis e a posição atual do usuário.
- Notícias editoriais sincronizadas em tempo real pelo Cloud Firestore.
- Notificações push pelo Firebase Cloud Messaging (FCM).
- Histórico local de notificações com deduplicação e limite de 100 itens.
- Favoritos persistidos no dispositivo.
- Assistente de IA com busca semântica local, contexto top-5 e cache de respostas.
- Interface em português e inglês.
- Fallback de notícias embarcadas quando o Firebase está indisponível.

## Tecnologias

| Área | Tecnologia |
|---|---|
| Aplicativo | Flutter e Dart |
| Plataforma alvo | Android |
| Gerenciamento de estado | Provider e ChangeNotifier |
| Dados remotos | Firebase Cloud Firestore |
| Notificações | Firebase Cloud Messaging |
| Persistência local | Shared Preferences |
| Mapas | Flutter Map e OpenStreetMap |
| Localização do dispositivo | Geolocator |
| IA | Gemini API, embeddings e similaridade de cosseno em Dart |
| Localização | Flutter Localizations |
| Testes | Flutter Test |

## Arquitetura

O código é organizado por funcionalidade e utiliza um fluxo de dados em camadas:

```text
lib/
├── core/          # configuração, tema, Firebase e localização
├── data/
│   ├── local/     # persistência no dispositivo
│   ├── models/    # modelos de domínio
│   ├── repositories/
│   └── services/  # Firestore, FCM, Gemini e fontes embarcadas
├── features/      # telas e providers agrupados por funcionalidade
└── shared/        # componentes reutilizáveis de interface
```

```text
Notícias:      Firestore → Service → Repository → Provider → UI
Notificações:  FCM → Service → Persistência local → Provider → UI
Assistente IA: Pergunta → Embedding → Cache semântico → Top-5 → Gemini → Cache
```

Essa separação mantém integrações de plataforma isoladas da apresentação e
permite testar providers, persistência e conversões de domínio de forma
independente.

## Requisitos

- Flutter compatível com Dart 3.6 ou superior.
- Android Studio e Android SDK, ou um dispositivo físico configurado.
- Projeto Firebase para notícias remotas e notificações push.
- Chave da Gemini API somente para habilitar o assistente de IA.
- Firebase CLI e FlutterFire CLI para reconfigurar ou publicar o Firebase.

## Instalação

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd cirioapp_v2
cp .env.example .env
flutter pub get
flutter run
```

No PowerShell, copie o arquivo de ambiente com:

```powershell
Copy-Item .env.example .env
```

Sem uma chave Gemini, somente o assistente fica indisponível. Se o Firebase não
puder ser inicializado, o app continua usando as notícias embarcadas e informa
claramente que as notificações não estão configuradas.

## Configuração de ambiente

Para desenvolvimento local, defina a chave Gemini em `.env`:

```env
GEMINI_API_KEY=sua_chave
```

Para builds, prefira uma definição em tempo de compilação:

```bash
flutter run --dart-define=GEMINI_API_KEY=sua_chave
flutter build apk --dart-define=GEMINI_API_KEY=sua_chave
```

> Segredos incluídos em aplicativos mobile podem ser extraídos do APK. Em
> produção, encaminhe as chamadas do modelo por um backend autenticado, aplique
> cotas e mantenha as credenciais do provedor no servidor.

## Configuração do Firebase

O pacote Android é `com.lianeheidemann.cirioapp`. O aplicativo Android no
Firebase, o arquivo `google-services.json` e as opções do FlutterFire devem usar
esse mesmo pacote. Alterá-lo após a publicação cria uma nova identidade de
aplicativo no Android e no Firebase.

Para conectar outro projeto Firebase:

```bash
firebase login
flutterfire configure
firebase use --add
firebase deploy --only firestore
```

O `flutterfire configure` gera `lib/firebase_options.dart` e configura a
integração Android. A configuração cliente do Firebase não é uma credencial
administrativa, mas contas de serviço e chaves de servidor nunca devem ser
versionadas.

### Notícias no Firestore

O app acompanha a coleção `news`, seleciona documentos com
`isPublished == true` e os ordena por `publishedAt`, do mais recente para o mais
antigo. As regras versionadas permitem leitura pública somente do conteúdo
publicado e bloqueiam escritas pelo cliente. As notícias devem ser administradas
pelo Console Firebase ou por um backend protegido.

Consulte [docs/firestore_news.md](docs/firestore_news.md) para ver o esquema, o
índice, as regras de segurança e o fluxo de publicação.

### Notificações pelo Cloud Messaging

O usuário ativa os avisos na página **Notificações**. Após conceder a permissão,
o dispositivo é inscrito no tópico `cirio_updates`. O aplicativo processa:

- mensagens recebidas enquanto o app está aberto;
- mensagens entregues enquanto o app está em segundo plano;
- notificações que abrem o app em segundo plano ou encerrado;
- payloads de notificação e payloads de dados com `title` e `body`.

Para avisos gerais do Círio, envie uma campanha pelo Console Firebase ou direcione
o tópico `cirio_updates` por um backend confiável com o Firebase Admin SDK. Não
envie mensagens FCM diretamente pelo aplicativo mobile.

No Android 13 ou superior, o usuário precisa conceder a permissão de notificações
do sistema. Se ela for negada, também poderá ser alterada posteriormente nas
configurações do aplicativo no Android.

## Localização e privacidade

Ao abrir o mapa, o aplicativo explica por que a localização é útil antes de
solicitar a permissão do sistema Android. O acesso é limitado ao período em que
o app está em uso; nenhuma permissão de localização em segundo plano é
solicitada. As coordenadas servem somente para centralizar o mapa e exibir o
marcador da posição atual — elas não são persistidas nem enviadas a um servidor.

Se o serviço de localização estiver desligado ou a permissão for bloqueada
permanentemente, o mapa continua disponível e oferece um atalho para a
configuração correspondente do Android.

## Assistente de IA e embeddings

Eventos, locais e perguntas frequentes são vetorizados offline e armazenados em
`assets/embeddings.json`. Durante o uso, somente a pergunta do usuário é
vetorizada. O app calcula a similaridade de cosseno localmente, seleciona os
cinco itens mais relevantes e envia esse contexto à Gemini. Respostas
semanticamente equivalentes podem ser reutilizadas pelo cache local.

Regere o asset de embeddings sempre que o corpus público mudar:

```bash
dart run tool/generate_embeddings.dart
```

O gerador lê `GEMINI_API_KEY` e, opcionalmente, `GEMINI_EMBEDDING_MODEL` do
ambiente ou do arquivo `.env`.

## Qualidade e testes

```bash
dart analyze
flutter test
flutter build apk --debug
```

A suíte atual cobre providers, persistência local, favoritos, widgets,
conversão de documentos Firestore, busca semântica, cache de respostas,
embeddings e histórico de notificações. Todas as verificações devem passar antes
de gerar uma versão de produção.

## Arquivos importantes

| Arquivo | Finalidade |
|---|---|
| `lib/main.dart` | Inicialização do aplicativo e registro dos providers |
| `lib/core/firebase/firebase_bootstrap.dart` | Inicialização tolerante a falhas do Firebase |
| `lib/data/services/firestore_news_service.dart` | Integração de notícias em tempo real |
| `lib/data/services/firebase_notifications_service.dart` | Tratamento do ciclo de vida do FCM |
| `lib/features/notifications/` | Estado e interface das notificações |
| `firestore.rules` | Política de acesso ao Firestore |
| `firestore.indexes.json` | Índices necessários do Firestore |
| `docs/firestore_news.md` | Documentação da coleção de notícias |

## Interface

<img src="assets/gif/interface_3.gif" alt="Demonstração do CírioApp" width="300" />
