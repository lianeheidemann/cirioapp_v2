<div align='center'>

[English](README.md) · **Português**

<img width='15%' src='assets/icon/icon.png' alt='Ícone do CírioApp'/>

# CírioApp

Aplicativo mobile sobre o Círio de Nazaré, em Belém do Pará.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square)

</div>

<img src='assets/images/interface_v3.png' />

## Funcionalidades

- **Eventos:** programação com datas, horários e locais.
- **Mapa interativo:** trajeto do Círio e pontos de interesse no OpenStreetMap.
- **Notícias:** conteúdo informativo com imagens locais.
- **Favoritos:** eventos, locais e notícias salvos no dispositivo.
- **Assistente IA com RAG local:** respostas contextualizadas usando busca semântica, top-5 e cache de perguntas semelhantes.
- **Português e inglês:** troca de idioma em tempo real.

## Tecnologias

- Flutter e Dart
- Provider para gerenciamento de estado
- Flutter Map e OpenStreetMap
- Shared Preferences para persistência local
- Flutter Localizations para internacionalização
- Gemini API via HTTP
- Embeddings locais e similaridade de cosseno em Dart puro

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

> Nunca envie o arquivo `.env` ou uma chave real para o repositório. Uma chave
> distribuída dentro de um APK pode ser extraída; a configuração direta no app
> é adequada apenas para desenvolvimento e demonstração. Em produção, use um
> backend/proxy com autenticação, limites de uso e a chave armazenada no servidor.

### Busca semântica e embeddings

O assistente usa uma implementação leve de RAG, sem banco vetorial externo:

1. Eventos, locais e FAQs são vetorizados offline no computador do desenvolvedor.
2. O corpus e seus vetores são gravados em `assets/embeddings.json`.
3. Para cada pergunta, o app faz uma única chamada ao endpoint de embeddings.
4. O app compara o vetor da pergunta com o corpus usando cosseno em Dart puro.
5. Somente os cinco itens mais próximos são adicionados ao prompt.
6. Se não houver uma resposta equivalente no cache, o app chama `generateContent`.
7. A resposta bem-sucedida é salva localmente para consultas futuras semelhantes.

O corpus completo nunca é enviado durante uma pergunta. A chamada de geração
recebe apenas as instruções, a pergunta e os itens recuperados pelo ranking.

### Gerar ou atualizar o asset

Sempre que eventos, locais ou FAQs forem alterados, regenere o asset:

```bash
dart run tool/generate_embeddings.dart
```

O script lê `GEMINI_API_KEY` do ambiente ou do `.env` e grava
`assets/embeddings.json`. O modelo padrão é `gemini-embedding-001`, sucessor
atual do descontinuado `text-embedding-004`. Os vetores são gerados com 768
dimensões para manter o asset compacto.

Para usar outro modelo compatível no PowerShell:

```powershell
$env:GEMINI_EMBEDDING_MODEL=nome-do-modelo
dart run tool/generate_embeddings.dart
```

Em Bash:

```bash
GEMINI_EMBEDDING_MODEL=nome-do-modelo dart run tool/generate_embeddings.dart
```

O gerador só substitui o asset depois que todos os documentos forem processados
e valida a dimensão devolvida pela API. O modelo e a dimensão ficam registrados
no JSON; em runtime, o app lê esses metadados para produzir a pergunta no mesmo
espaço vetorial.

### Cache semântico

- Persistido no dispositivo com Shared Preferences.
- Limitado às 50 respostas mais recentes.
- Reutiliza uma resposta quando a similaridade é igual ou superior a `0.94`.
- Separa entradas por idioma e modelo de embeddings.
- Perguntas sem correspondência continuam pelo fluxo normal de RAG e geração.

## Arquitetura

O projeto utiliza uma organização por funcionalidades com separação em camadas:

- `features`: telas e providers de cada funcionalidade.
- `data/services`: fontes de dados locais e integrações externas.
- `data/repositories`: comunicação entre serviços e regras da aplicação.
- `core`: tema, constantes e localização.
- `shared`: componentes reutilizáveis da interface.

O estado é gerenciado com `ChangeNotifier`, `Provider` e `ChangeNotifierProxyProvider`.

Arquivos principais do assistente:

- `tool/generate_embeddings.dart`: gera o corpus vetorial offline.
- `assets/embeddings.json`: corpus empacotado no aplicativo.
- `lib/data/services/gemini_service.dart`: chamadas de embedding e geração.
- `lib/data/services/semantic_search_service.dart`: carregamento, validação, cosseno e top-5.
- `lib/data/local/ai_response_cache.dart`: cache semântico persistente.
- `lib/data/repositories/ai_assistant_repository.dart`: orquestra cache, recuperação e prompt.
- `lib/core/constants/ai_faqs.dart`: fonte única das FAQs da interface e do corpus.

## Testes

Os testes cobrem providers, persistência de favoritos, widgets, similaridade de
cosseno, validação do asset, ranking top-5 e isolamento do cache por idioma.

```bash
dart analyze
flutter test
```

## Interface

<img src='assets/gif/interface_3.gif' alt='Interface do CírioApp' width='50%' />

