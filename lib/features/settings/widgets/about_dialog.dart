import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'pp_license_page.dart';

class PpAboutDialog extends StatelessWidget {
  const PpAboutDialog({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.aboutApp,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n.close,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Main content (scrollable on small screens)
              Flexible(
                child: SingleChildScrollView(
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final packageInfo = snapshot.data;
                      final version = packageInfo?.version ?? '';
                      final build = packageInfo?.buildNumber ?? '';
                      final isBeta = version.toLowerCase().contains('beta');

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hero
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 80,
                              height: 80,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'PPPlayer',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.appTagline,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.aboutDescription,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // Version Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.versionInfo(version, build),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isBeta) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'BETA',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Primary Links Grid
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isNarrow = constraints.maxWidth < 400;
                              final crossAxisCount = isNarrow ? 1 : 2;

                              return GridView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      mainAxisExtent: 80,
                                    ),
                                children: [
                                  _buildLinkCard(
                                    context,
                                    icon: Icons.public,
                                    title: l10n.website,
                                    subtitle: l10n.exploreApp,
                                    url: 'https://ppplayer.com',
                                  ),
                                  _buildLinkCard(
                                    context,
                                    icon: Icons.code,
                                    title: l10n.github,
                                    subtitle: l10n.viewSource,
                                    url:
                                        'https://github.com/ppplayermusic/ppplayer',
                                  ),
                                  _buildLinkCard(
                                    context,
                                    icon: Icons.article_outlined,
                                    title: l10n.releaseNotes,
                                    subtitle: l10n.seeWhatsNew,
                                    url:
                                        'https://github.com/ppplayermusic/ppplayer/releases',
                                  ),
                                  _buildLinkCard(
                                    context,
                                    icon: Icons.help_outline,
                                    title: l10n.support,
                                    subtitle: l10n.getHelp,
                                    url: 'https://ppplayer.com/support',
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          // Footer
                          Divider(
                            color: theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.createdBy,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.instagram,
                                  size: 20,
                                ),
                                onPressed: () => _launchUrl(
                                  'https://www.instagram.com/ppplayermusic/',
                                ),
                                tooltip: 'Instagram',
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 20,
                                ),
                                onPressed: () => _launchUrl(
                                  'https://www.facebook.com/ppplayermusic',
                                ),
                                tooltip: 'Facebook',
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  size: 20,
                                ),
                                onPressed: () => _launchUrl(
                                  'https://www.linkedin.com/company/ppplayer/',
                                ),
                                tooltip: 'LinkedIn',
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              TextButton(
                                onPressed: () => _showProjectLicense(context),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      theme.colorScheme.onSurfaceVariant,
                                ),
                                child: Text(l10n.license),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PPLicensePage(
                                        applicationName: 'PPPlayer',
                                        applicationVersion: version,
                                        applicationLegalese: l10n.copyright(
                                          DateTime.now().year.toString(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      theme.colorScheme.onSurfaceVariant,
                                ),
                                child: Text(l10n.acknowledgments),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.copyright(DateTime.now().year.toString()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchUrl(url),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.open_in_new,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectLicense(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.license),
          content: FutureBuilder<String>(
            future: DefaultAssetBundle.of(context).loadString('assets/LICENSE'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Text(
                    snapshot.data!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }
}
