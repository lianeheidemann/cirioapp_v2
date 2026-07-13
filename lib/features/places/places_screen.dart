import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/place_model.dart';
import '../../shared/widgets/app_loading.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/favorite_button.dart';
import 'place_detail_screen.dart';
import 'places_provider.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});
  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<PlacesProvider>().loadPlaces());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CirioAppBar(
            title: tr(context, 'Locais', 'Places'),
            subtitle: tr(context, 'Pontos úteis e lugares para conhecer',
                'Useful places and sights')),
        body: Consumer<PlacesProvider>(builder: (context, p, _) {
          if (p.isLoading) {
            return const AppLoadingList();
          }
          if (p.errorMessage != null) {
            return EmptyStateWidget(
                icon: Icons.error_outline,
                title:
                    tr(context, 'Locais indisponíveis', 'Places unavailable'),
                message: p.errorMessage!,
                onRetry: p.loadPlaces);
          }
          return Column(children: [
            SizedBox(
                height: 62,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: p.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = p.categories[i];
                    return FilterChip(
                        label: Text(ContentTranslations.category(context, cat)),
                        selected: p.selectedCategory == cat,
                        showCheckmark: false,
                        onSelected: (_) => p.setCategory(cat),
                        labelStyle: TextStyle(
                            color: p.selectedCategory == cat
                                ? Colors.white
                                : AppColors.navy,
                            fontWeight: FontWeight.w600));
                  },
                )),
            Expanded(
                child: p.filteredPlaces.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.location_off_outlined,
                        message: tr(context, 'Nenhum local nesta categoria.',
                            'No places in this category.'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                        itemCount: p.filteredPlaces.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final place = p.filteredPlaces[i];
                          return _PlaceCard(
                              place: place,
                              onFavorite: () => p.toggleFavorite(place),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          PlaceDetailScreen(place: place))));
                        },
                      )),
          ]);
        }),
      );
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  const _PlaceCard(
      {required this.place, required this.onTap, required this.onFavorite});
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.divider)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                          color: AppColors.softBlue,
                          borderRadius: BorderRadius.circular(18)),
                      child: Icon(_icon(place.category),
                          color: AppColors.secondaryBlue)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                            ContentTranslations.place(
                                context, place, 'category'),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: AppColors.secondaryBlue)),
                        const SizedBox(height: 4),
                        Text(ContentTranslations.place(context, place, 'name'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Row(children: [
                          const Icon(Icons.location_on_outlined,
                              size: 15, color: AppColors.muted),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(
                                  ContentTranslations.place(
                                      context, place, 'address'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall))
                        ]),
                      ])),
                  FavoriteButton(
                      isFavorite: place.isFavorite, onTap: onFavorite),
                ]))),
      );
}

IconData _icon(String category) {
  switch (category) {
    case AppConstants.categoryChurch:
      return Icons.church_outlined;
    case AppConstants.categoryHydration:
      return Icons.water_drop_outlined;
    case AppConstants.categoryFood:
      return Icons.restaurant_outlined;
    case AppConstants.categoryHealth:
      return Icons.local_hospital_outlined;
    case AppConstants.categoryRestroom:
      return Icons.wc_outlined;
    case AppConstants.categoryTourism:
      return Icons.explore_outlined;
    default:
      return Icons.location_on_outlined;
  }
}
