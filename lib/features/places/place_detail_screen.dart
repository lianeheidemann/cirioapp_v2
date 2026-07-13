import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/content_translations.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/place_model.dart';
import '../../shared/widgets/cirio_app_bar.dart';
import '../../shared/widgets/favorite_button.dart';
import 'places_provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  final PlaceModel place;
  const PlaceDetailScreen({super.key, required this.place});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CirioAppBar(
            title: tr(context, 'Detalhes do local', 'Place details'),
            actions: [
              Consumer<PlacesProvider>(builder: (_, p, __) {
                final current = p.places.firstWhere(
                    (item) => item.id == place.id,
                    orElse: () => place);
                return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FavoriteButton(
                        isFavorite: current.isFavorite,
                        onTap: () => p.toggleFavorite(current)));
              })
            ]),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.navy, AppColors.secondaryBlue]),
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(18)),
                            child: const Icon(Icons.location_on_outlined,
                                color: AppColors.gold)),
                        const SizedBox(height: 16),
                        Text(
                            ContentTranslations.place(
                                    context, place, 'category')
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: AppColors.gold, letterSpacing: .8)),
                        const SizedBox(height: 8),
                        Text(ContentTranslations.place(context, place, 'name'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white)),
                      ])),
              const SizedBox(height: 16),
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.divider)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: AppColors.secondaryBlue),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(tr(context, 'Endereço', 'Address'),
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                  ContentTranslations.place(
                                      context, place, 'address'),
                                  style: Theme.of(context).textTheme.titleSmall)
                            ])),
                      ])),
              const SizedBox(height: 24),
              Text(tr(context, 'Sobre este local', 'About this place'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(ContentTranslations.place(context, place, 'description'),
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.softBlue,
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(children: [
                    const Icon(Icons.gps_fixed_rounded,
                        color: AppColors.secondaryBlue),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            '${tr(context, 'Coordenadas', 'Coordinates')}: ${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                            style: Theme.of(context).textTheme.bodySmall))
                  ])),
              const SizedBox(height: 32),
            ])),
      );
}
