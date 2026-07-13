import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_language.dart';
import '../../core/theme/app_theme.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../events/events_screen.dart';
import '../favorites/favorites_screen.dart';
import '../map/map_screen.dart';
import '../news/news_screen.dart';
import '../notifications/notifications_screen.dart';
import '../places/places_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final english = language.isEnglish;
    final links = [
      (
        english ? 'Events' : 'Eventos',
        Icons.calendar_month_outlined,
        const EventsScreen()
      ),
      (english ? 'Map' : 'Mapa', Icons.map_outlined, const MapScreen()),
      (
        english ? 'News' : 'Notícias',
        Icons.newspaper_outlined,
        const NewsScreen()
      ),
      (
        english ? 'Places' : 'Locais',
        Icons.location_on_outlined,
        const PlacesScreen()
      ),
      (
        english ? 'Favorites' : 'Favoritos',
        Icons.favorite_border_rounded,
        const FavoritesScreen()
      ),
      (
        english ? 'AI Assistant' : 'Assistente IA',
        Icons.auto_awesome_outlined,
        const AiAssistantScreen()
      ),
    ];
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.paddingOf(context).top + 20, 24, 48),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.navy, AppColors.secondaryBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.extraLarge),
              ),
            ),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 54),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          english ? 'HELLO, PILGRIM' : 'OLÁ, PEREGRINO',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.gold,
                                    letterSpacing: 1.4,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          english
                              ? 'Círio is now\ncloser to you.'
                              : 'O Círio está\nmais perto de você.',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          english
                              ? 'Information, faith and care at every moment.'
                              : 'Informação, fé e cuidado em cada momento.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 104,
                    height: 104,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .28),
                      ),
                      boxShadow: AppShadows.floating,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ]),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _LanguageButton(language: language),
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          sliver: SliverList.list(children: [
            Transform.translate(
              offset: Offset.zero,
              child: _ActionCard(
                icon: Icons.notifications_none_rounded,
                title: english ? 'Notifications' : 'Notificações',
                subtitle: english
                    ? 'Important alerts and guidance'
                    : 'Avisos e orientações importantes',
                onTap: () => _open(context, const NotificationsScreen()),
              ),
            ),
            const SizedBox(height: 26),
            _HomeSectionHeader(
              title: english ? 'Quick access' : 'Acessos rápidos',
              subtitle: english
                  ? 'Everything you need for Círio'
                  : 'Tudo para viver o Círio com tranquilidade',
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
                builder: (_, constraints) => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: links.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth >= 600 ? 3 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.8),
                      itemBuilder: (_, i) => _QuickCard(
                          label: links[i].$1,
                          icon: links[i].$2,
                          gold: i == 5,
                          onTap: () => _open(context, links[i].$3)),
                    )),
            const SizedBox(height: 24),
            Text(english ? 'Important information' : 'Informações importantes',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(28)),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.gold, size: 28),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          english
                              ? 'Next major procession'
                              : 'Próxima grande procissão',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                          english
                              ? 'Círio of Nazaré • October 11, 2026 at 7:00 AM'
                              : 'Círio de Nazaré • 11 de outubro de 2026, às 07:00',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70)),
                    ])),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ActionCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.divider),
            boxShadow: AppShadows.soft),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                            color: AppColors.softGold, shape: BoxShape.circle),
                        child: Icon(icon, color: AppColors.gold)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(title,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(subtitle,
                              style: Theme.of(context).textTheme.bodySmall),
                        ])),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 17, color: AppColors.navy),
                  ]),
                ))),
      );
}

class _QuickCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool gold;
  final VoidCallback onTap;
  const _QuickCard(
      {required this.label,
      required this.icon,
      required this.gold,
      required this.onTap});

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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: gold ? AppColors.softGold : AppColors.softBlue,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(icon,
                          color:
                              gold ? AppColors.gold : AppColors.secondaryBlue)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(label,
                          style: Theme.of(context).textTheme.titleSmall)),
                ]))),
      );
}

class _HomeSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HomeSectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      );
}

class _LanguageButton extends StatelessWidget {
  final LanguageProvider language;

  const _LanguageButton({required this.language});

  @override
  Widget build(BuildContext context) => Semantics(
        label: language.isEnglish
            ? 'Current language: English'
            : 'Idioma atual: português',
        child: Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: Colors.white.withValues(alpha: .22),
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.language_rounded,
                size: 18,
                color: language.isEnglish ? Colors.white70 : AppColors.gold,
              ),
            ),
            _LanguageOption(
              label: 'PT',
              selected: !language.isEnglish,
              onTap: language.isEnglish ? language.toggleLanguage : null,
            ),
            const SizedBox(width: 2),
            _LanguageOption(
              label: 'EN',
              selected: language.isEnglish,
              onTap: language.isEnglish ? null : language.toggleLanguage,
            ),
          ]),
        ),
      );
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: selected ? AppColors.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected ? AppColors.navy : Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ),
      );
}
