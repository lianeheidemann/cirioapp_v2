import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/news_model.dart';

/// Capa que prioriza a URL atualizável do Firestore e mantém o asset local
/// como fallback para falhas de rede ou documentos antigos.
class NewsCoverImage extends StatelessWidget {
  final NewsModel news;
  final double height;

  const NewsCoverImage({
    super.key,
    required this.news,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: double.infinity,
      color: AppColors.softBlue,
      child: const Center(
        child: Icon(
          Icons.photo_outlined,
          size: 40,
          color: AppColors.secondaryBlue,
        ),
      ),
    );

    Widget localFallback() {
      final asset = news.imageAsset;
      if (asset == null || asset.isEmpty) return placeholder;
      return Image.asset(
        asset,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    final url = news.imageUrl;
    if (url == null || url.isEmpty) return localFallback();
    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => localFallback(),
    );
  }
}
