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

CírioApp é um aplicativo mobile desenvolvido em Flutter que centraliza informações sobre o Círio de Nazaré, incluindo programação de eventos, mapa interativo, notícias e sistema de favoritos.

---

## Funcionalidades

- Eventos — Calendário completo com datas, horários e locais
- Mapa Interativo — OpenStreetMap com pontos de interesse categorizados
- Notícias — Feed atualizado com conteúdo sobre o Círio
- Favoritos — Sistema sincronizado para eventos, locais e notícias
- Persistência Local — Dados salvos automaticamente
- Assistente IA — Chat com IA generativa (Gemini) para tirar dúvidas sobre o Círio

---

## Tecnologias

| Tecnologia | Versão |
|---|---|
| Flutter | 3.16+ |
| Dart | 3.0+ |
| Provider | ^6.1.2 |
| flutter_map | ^7.0.2 |
| shared_preferences | ^2.2.3 |
| cached_network_image | ^3.3.1 |
| http | ^1.2.2 |

---

## Como Executar

Pré-requisitos:
- Flutter SDK `>=3.0.0 <4.0.0`
- Android SDK 21+
- Conexão com internet

Passos:

```bash
git clone https://github.com/lianeheidemann/cirioapp_v2.git
cd novo_CirioApp
flutter pub get
flutter run
```

---

## Estrutura de Arquivos

```
lib/
├── main.dart                      
├── app.dart                      
├── core/
│   ├── theme/app_theme.dart       
│   └── constants/
│       ├── app_constants.dart
│       └── gemini_config.dart
├── data/
│   ├── models/                
│   ├── services/
│   │   └── gemini_service.dart
│   ├── repositories/
│   │   └── ai_assistant_repository.dart
│   └── local/                 
├── features/
│   ├── home/         
│   ├── events/               
│   ├── places/                   
│   ├── map/              
│   ├── news/      
│   ├── favorites/
│   └── ai_assistant/
│       ├── ai_assistant_screen.dart
│       └── ai_assistant_provider.dart
└── shared/widgets/   
```

---

## Como configurar a Gemini API Key

1. Gere uma chave gratuita em [Google AI Studio](https://aistudio.google.com/app/apikey).
2. **Nunca** cole a chave diretamente no código. Rode o app passando a chave via `--dart-define`:

   ```bash
   flutter run --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
   ```

   Para builds de release:

   ```bash
   flutter build apk --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
   ```

---

<img width="100%" src="https://github.com/lianeheidemann/cirioapp_v2/blob/main/assets/image/image-2.png" alt="CírioApp Screenshots" />

<!--
---

## Assistente IA do Círio

### O que é

O **Assistente IA do Círio** é uma funcionalidade de chat com IA generativa que responde perguntas sobre o Círio de Nazaré e Belém do Pará — programação de eventos, locais e pontos de interesse, hidratação, saúde, turismo e segurança. Ele usa os dados que já existem no app (eventos e locais mockados) como contexto para gerar respostas mais relevantes, sem depender de backend próprio ou banco de dados vetorial.

A tela oferece:
- campo de texto livre para qualquer pergunta;
- botões de perguntas rápidas ("Roteiro para primeira vez no Círio", "Onde encontrar hidratação?", "Quais locais turísticos visitar?", "Dicas de segurança");
- indicador de carregamento durante a chamada à IA;
- exibição da resposta e tratamento de erros (chave ausente, falha de rede, erro da API).

### Tecnologias utilizadas

| Camada | Responsabilidade |
|---|---|
| `GeminiService` (`data/services`) | Chamada HTTP direta ao endpoint `generateContent` da Gemini API |
| `AiAssistantRepository` (`data/repositories`) | Monta o contexto (eventos + locais) e o prompt final |
| `AiAssistantProvider` (`features/ai_assistant`) | Estado da tela (`ChangeNotifier`): loading, resposta, erro |
| `AiAssistantScreen` (`features/ai_assistant`) | Interface do chat |
| `GeminiConfig` (`core/constants`) | Configuração isolada da API key |

Não é usado LangChain, RAG real, banco vetorial, autenticação de usuário nem Firebase — o "contexto" enviado à IA é apenas um resumo em texto simples dos eventos e locais já cadastrados no app.

### Como configurar a Gemini API Key

1. Gere uma chave gratuita em [Google AI Studio](https://aistudio.google.com/app/apikey).
2. **Nunca** cole a chave diretamente no código. Rode o app passando a chave via `--dart-define`:

   ```bash
   flutter run --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
   ```

   Para builds de release:

   ```bash
   flutter build apk --dart-define=GEMINI_API_KEY=SUA_CHAVE_AQUI
   ```

3. (Opcional, apenas para testes rápidos locais) você pode preencher `fallbackApiKey` em `lib/core/constants/gemini_config.dart` — mas **não faça commit** de uma chave real nesse arquivo.
4. Sem chave configurada, a tela do Assistente IA exibe uma mensagem de erro amigável explicando que a chave precisa ser configurada, em vez de travar o app.

### Limitações

- Sem backend: a chave da API roda embutida no app (`--dart-define`), o que é aceitável para protótipos/estudos, mas **não é recomendado para produção** — nesse caso, o ideal é um proxy backend que guarde a chave no servidor.
- Contexto simples: o resumo de eventos e locais é enviado por inteiro a cada pergunta, sem busca semântica (RAG). Funciona bem para o volume atual de dados mockados, mas não escala para uma base muito grande.
- Sem histórico de conversa: cada pergunta é tratada de forma isolada (sem memória de perguntas anteriores).
- Sem cache de respostas: perguntas repetidas geram novas chamadas à API.
- Depende de conexão com a internet.

### Melhorias futuras

- Adicionar histórico de conversa (multi-turn) mantendo o contexto entre perguntas.
- Cache local de perguntas frequentes para reduzir custo e latência.
- Mover a chamada à Gemini API para um backend simples (proxy), removendo a chave do app.
- Incluir notícias no contexto enviado à IA, além de eventos e locais.
- Streaming da resposta (exibir o texto sendo gerado em tempo real).
- Favoritar/compartilhar respostas do assistente.

---


