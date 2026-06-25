import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'news_provider.dart';
import 'news_detail_screen.dart';

/// Tela de listagem de notícias.
///
/// Exibe cards com imagem destacada, título, data e resumo.
/// Usa [CachedNetworkImage] para carregar e cachear imagens.
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CirioAppBar(title: 'Notícias'),
      body: Consumer<NewsProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.news.isEmpty) {
            return const EmptyStateWidget(
                icon: Icons.newspaper, message: 'Nenhuma notícia encontrada.');
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.news.length,
            itemBuilder: (_, i) {
              final article = provider.news[i];
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailScreen(news: article),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.imageUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: article.imageUrl!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              height: 140,
                              color:
                                  AppTheme.primaryBlue.withValues(alpha: 0.1),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              height: 140,
                              color:
                                  AppTheme.primaryBlue.withValues(alpha: 0.1),
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              article.date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.accentGold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              article.summary,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
