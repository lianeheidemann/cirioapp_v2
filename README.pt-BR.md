<div align='center'>

<img width='15%' src='assets/icon/icon.png' alt='Ícone do CírioApp'/>

# CírioApp

Aplicativo mobile sobre o Círio de Nazaré, em Belém do Pará.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square)

</div>

<img src='assets/images/GridArt_20260713_051055219.png' />

## Funcionalidades

- **Eventos:** programação com datas, horários e locais.
- **Mapa interativo:** trajeto do Círio e pontos de interesse no OpenStreetMap.
- **Notícias:** conteúdo informativo com imagens locais.
- **Favoritos:** eventos, locais e notícias salvos no dispositivo.
- **Assistente IA:** respostas contextualizadas sobre o Círio e Belém com a Gemini API.
- **Português e inglês:** troca de idioma em tempo real.

## Tecnologias

- Flutter e Dart
- Provider para gerenciamento de estado
- Flutter Map e OpenStreetMap
- Shared Preferences para persistência local
- Flutter Localizations para internacionalização
- Gemini API via HTTP

## Como executar

Tenha o Flutter SDK instalado e um dispositivo ou emulador Android configurado.

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd cirioapp_v2
flutter pub get
flutter run
```

O mapa e o assistente de IA precisam de conexão com a internet. Os demais conteúdos estão disponíveis localmente.

## Assistente IA

A configuração da Gemini API é opcional. Sem uma chave, apenas o assistente fica indisponível.

Para desenvolvimento local, copie `.env.example` para `.env` e informe a chave:

```env
GEMINI_API_KEY=sua_chave
```

Também é possível fornecê-la durante a execução:

```bash
flutter run --dart-define=GEMINI_API_KEY=SUA_CHAVE
```

> Nunca envie o arquivo `.env` ou uma chave real para o repositório.

## Arquitetura

O projeto utiliza uma organização por funcionalidades com separação em camadas:

- `features`: telas e providers de cada funcionalidade.
- `data/services`: fontes de dados locais e integrações externas.
- `data/repositories`: comunicação entre serviços e regras da aplicação.
- `core`: tema, constantes e localização.
- `shared`: componentes reutilizáveis da interface.

O estado é gerenciado com `ChangeNotifier`, `Provider` e `ChangeNotifierProxyProvider`.

## Testes

Os testes cobrem providers, persistência de favoritos e widgets principais.


```bash
flutter test
```

## Interface

<img src='assets/gif/interface_3.gif' alt='Interface do CírioApp' width='50%' />

