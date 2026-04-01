import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/spotify_client.dart';
import '../../core/services/settings_provider.dart';
import '../../core/db/app_database.dart' as db;
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/premium_modals.dart';

final availableMarketsProvider = FutureProvider<List<String>>((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getAvailableMarkets();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Glassmorphic App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            elevation: 0,
            leading: TactileIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
              color: Colors.white,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: _SettingsHero().animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
          ),

          // Settings Groups
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader('Preferences'),
                const SizedBox(height: 12),
                TactileSettingTile(
                  title: 'Content Market',
                  subtitle: 'Current: ${settings.selectedCountry}',
                  icon: Icons.public_rounded,
                  onTap: () => _showCountryPicker(context, ref),
                ),
                const SizedBox(height: 12),
                TactileSwitchTile(
                  title: 'Show Video Player',
                  subtitle: 'Use YouTube player when available',
                  icon: Icons.smart_display_rounded,
                  value: settings.showVideo,
                  onChanged: (v) => ref.read(settingsProvider.notifier).toggleVideo(),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('Data & Storage'),
                const SizedBox(height: 12),
                TactileSettingTile(
                  title: 'Clear Recently Played',
                  subtitle: 'Permanently remove listening history',
                  icon: Icons.history_rounded,
                  color: Colors.redAccent.withValues(alpha: 0.8),
                  onTap: () => _showClearHistoryConfirm(context, ref),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('About'),
                const SizedBox(height: 12),
                const TactileSettingTile(
                  title: 'App version',
                  subtitle: '0.1.0 Premium Beta',
                  icon: Icons.info_outline_rounded,
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showClearHistoryConfirm(BuildContext context, WidgetRef ref) {
    showPremiumModal(
      context: context,
      title: 'Clear History?',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This will permanently remove your listening history. This action cannot be undone.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TactileTap(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TactileTap(
                  onTap: () async {
                    await ref.read(db.appDatabaseProvider).clearHistory();
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Clear All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCountryPicker(BuildContext context, WidgetRef ref) {
    showPremiumModal(
      context: context,
      title: 'Select Market',
      child: SizedBox(
        height: 450,
        child: Consumer(
          builder: (context, ref, _) {
            final marketsAsync = ref.watch(availableMarketsProvider);
            final currentCountry = ref.watch(selectedCountryProvider);

            return marketsAsync.when(
              data: (markets) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: markets.length,
                  itemBuilder: (context, index) {
                    final code = markets[index];
                    final isSelected = code == currentCountry;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TactileTap(
                        onTap: () {
                          ref.read(settingsProvider.notifier).setCountry(code);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.white24 : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF1DB954) : Colors.white10,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    code.substring(0, index < 2 ? code.length : 2),
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                code,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected) const Icon(Icons.check_rounded, color: Color(0xFF1DB954), size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
              error: (err, _) => Center(child: Text('Error loding markets: $err')),
            );
          },
        ),
      ),
    );
  }
}

class _SettingsHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Mesh Gradient / Ambient Background
            Positioned.fill(
              child: CustomPaint(
                painter: _MeshPainter(),
              ),
            ),
            // Glass Surface
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.01),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1DB954).withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ppplayer',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'PRO EXPERIENCE ACTIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: const Color(0xFF1DB954).withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    // Primary Brand Blob
    paint.color = const Color(0xFF1DB954).withValues(alpha: 0.15);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 80, paint);

    // Secondary Accent Blob
    paint.color = Colors.blueAccent.withValues(alpha: 0.1);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 60, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TactileSettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  const TactileSettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? Colors.white).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color ?? Colors.white70, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.2),
              ),
          ],
        ),
      ),
    );
  }
}

class TactileSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const TactileSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.smart_display_rounded, color: Colors.white70, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFF1DB954).withValues(alpha: 0.5),
            activeThumbColor: const Color(0xFF1DB954),
            onChanged: (v) {
              HapticFeedback.mediumImpact();
              onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
