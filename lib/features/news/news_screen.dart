import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/news_model.dart';
import '../../shared/widgets/app_loading.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'news_detail_screen.dart';
import 'news_cover_image.dart';
import 'news_provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<NewsProvider>().loadNews());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CirioAppBar(
            title: tr(context, 'Notícias', 'News'),
            subtitle: tr(context, 'Informação para acompanhar o Círio',
                'Information to follow Círio')),
        body: Consumer<NewsProvider>(builder: (context, p, _) {
          if (p.isLoading) {
            return const AppLoadingList();
          }
          if (p.errorMessage != null) {
            return EmptyStateWidget(
                icon: Icons.error_outline,
                title:
                    tr(context, 'Notícias indisponíveis', 'News unavailable'),
                message: p.errorMessage!,
                onRetry: p.loadNews);
          }
          if (p.news.isEmpty) {
            return EmptyStateWidget(
                icon: Icons.newspaper_outlined,
                message: tr(
                    context, 'Nenhuma notícia encontrada.', 'No news found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: p.news.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) => _NewsCard(
                article: p.news[i],
                featured: i == 0,
                onFavorite: () => p.toggleFavorite(p.news[i]),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(news: p.news[i])))),
          );
        }),
      );
}

class _NewsCard extends StatelessWidget {
  final NewsModel article;
  final bool featured;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  const _NewsCard(
      {required this.article,
      required this.featured,
      required this.onTap,
      required this.onFavorite});
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.divider)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                NewsCoverImage(news: article, height: featured ? 190 : 150),
                if (featured)
                  Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(999)),
                          child: Text(tr(context, 'DESTAQUE', 'FEATURED'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .6)))),
                Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton.filledTonal(
                        onPressed: onFavorite,
                        tooltip:
                            tr(context, 'Favoritar notícia', 'Favorite news'),
                        style: IconButton.styleFrom(
                            backgroundColor: AppColors.surface),
                        icon: Icon(
                            article.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: article.isFavorite
                                ? AppColors.gold
                                : AppColors.navy))),
              ]),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 14, color: AppColors.gold),
                          const SizedBox(width: 6),
                          Text(
                              ContentTranslations.news(
                                  context, article, 'date'),
                              style: Theme.of(context).textTheme.bodySmall)
                        ]),
                        const SizedBox(height: 8),
                        Text(
                            ContentTranslations.news(context, article, 'title'),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                            ContentTranslations.news(
                                context, article, 'summary'),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.muted)),
                      ])),
            ])),
      );
}
