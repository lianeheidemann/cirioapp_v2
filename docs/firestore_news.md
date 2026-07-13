# Banco de notícias no Cloud Firestore

O aplicativo lê em tempo real a coleção `news`. Cada documento representa uma
notícia e usa o próprio ID do Firestore como `NewsModel.id`.

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---:|---|
| `title` | string | sim | Título em português |
| `date` | string | sim | Data formatada para exibição |
| `summary` | string | sim | Resumo do card |
| `content` | string | sim | Texto completo |
| `publishedAt` | timestamp | sim | Ordenação cronológica |
| `isPublished` | boolean | sim | Somente `true` aparece no app |
| `imageUrl` | string | não | URL HTTPS da capa |
| `imageAsset` | string | não | Asset local usado como fallback |
| `titleEn` | string | não | Título em inglês |
| `dateEn` | string | não | Data em inglês |
| `summaryEn` | string | não | Resumo em inglês |
| `contentEn` | string | não | Conteúdo em inglês |

## Configuração

1. Crie um projeto no Console Firebase.
2. Ative o Cloud Firestore em modo de produção.
3. Instale as CLIs do Firebase e FlutterFire.
4. Na raiz do projeto, execute `firebase login`.
5. Execute `flutterfire configure`.
6. Execute `firebase use --add`.
7. Publique regras e índice com `firebase deploy --only firestore`.

`flutterfire configure` substitui o placeholder `lib/firebase_options.dart`
pelas opções do projeto e configura a plataforma Android. Essas opções não são
uma chave administrativa e devem ser versionadas para o app inicializar.

## Publicação

Crie ou edite documentos pelo Console Firebase. Use `isPublished: false` para
rascunhos e altere para `true` somente quando o documento estiver completo.

As regras permitem leitura pública apenas de notícias publicadas e bloqueiam
qualquer escrita pelo aplicativo. Não altere para escrita pública.
