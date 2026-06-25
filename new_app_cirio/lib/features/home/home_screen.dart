import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../events/events_screen.dart';
import '../places/places_screen.dart';
import '../map/map_screen.dart';
import '../news/news_screen.dart';
import '../favorites/favorites_screen.dart';

/// Tela inicial com hero SliverAppBar e grid de acesso rápido.
///
/// Exibe um gradiente azul com ícone do Círio, navegação rápida para
/// as 5 seções principais (Eventos, Mapa, Notícias, Pontos, Favoritos)
/// e um card informativo com a data da próxima procissão.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeroAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Acesso Rápido'),
                  const SizedBox(height: 12),
                  _buildQuickAccessGrid(context),
                  const SizedBox(height: 24),
                  _buildInfoCard(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppTheme.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'CírioApp',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, Color(0xFF0D2137)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.church, color: AppTheme.accentGold, size: 52),
              const SizedBox(height: 8),
              Text(
                'Círio de Nazaré 2025',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.accentGold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Belém do Pará',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    final items = [
      _QuickAccessItem(
        label: 'Eventos',
        icon: Icons.event,
        color: const Color(0xFF1A3A6B),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventsScreen()),
        ),
      ),
      _QuickAccessItem(
        label: 'Mapa',
        icon: Icons.map,
        color: const Color(0xFF2E7D32),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapScreen()),
        ),
      ),
      _QuickAccessItem(
        label: 'Notícias',
        icon: Icons.newspaper,
        color: const Color(0xFF6A1B9A),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewsScreen()),
        ),
      ),
      _QuickAccessItem(
        label: 'Pontos de\nInteresse',
        icon: Icons.place,
        color: const Color(0xFFB71C1C),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlacesScreen()),
        ),
      ),
      _QuickAccessItem(
        label: 'Favoritos',
        icon: Icons.favorite,
        color: AppTheme.accentGold,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        ),
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: items.map((item) => _QuickAccessCard(item: item)).toList(),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppTheme.accentGold, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próxima procissão',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '12 de outubro de 2025 — 07:00h',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.accentGold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickAccessItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _QuickAccessCard extends StatelessWidget {
  final _QuickAccessItem item;

  const _QuickAccessCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: item.color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
