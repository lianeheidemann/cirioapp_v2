import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/news_model.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/favorite_button.dart';
import 'news_provider.dart';
import 'news_cover_image.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;
  const NewsDetailScreen({super.key, required this.news});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CirioAppBar(title: tr(context, 'Notícia', 'News'), actions: [
          Consumer<NewsProvider>(builder: (_, p, __) {
            final current =
                p.news.firstWhere((n) => n.id == news.id, orElse: () => news);
            return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FavoriteButton(
                    isFavorite: current.isFavorite,
                    onTap: () => p.toggleFavorite(current)));
          })
        ]),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: NewsCoverImage(news: news, height: 240)),
          SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList.list(children: [
                Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 15, color: AppColors.gold),
                  const SizedBox(width: 7),
                  Text(ContentTranslations.news(context, news, 'date'),
                      style: Theme.of(context).textTheme.bodySmall)
                ]),
                const SizedBox(height: 12),
                Text(ContentTranslations.news(context, news, 'title'),
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Container(
                    width: 48,
                    height: 3,
                    decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 20),
                Text(ContentTranslations.news(context, news, 'summary'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryBlue)),
                const SizedBox(height: 20),
                Text(ContentTranslations.news(context, news, 'content'),
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 32),
              ])),
        ]),
      );
}
