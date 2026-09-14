import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.all(32),
      content: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final packageInfo = snapshot.data;
          final version = packageInfo?.version ?? '';
          final build = packageInfo?.buildNumber ?? '';
          
          // Show beta badge if the version string contains 'beta'
          final isBeta = version.toLowerCase().contains('beta');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 80,
                    height: 80,
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
                  l10n.aboutDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'BETA',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.createdBy,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildActionButton(context, Icons.public, l10n.website, 'https://ppplayer.com'),
                    _buildActionButton(context, Icons.code, l10n.github, 'https://github.com/ppplayermusic/ppplayer'),
                    _buildActionButton(context, Icons.article_outlined, l10n.releaseNotes, 'https://github.com/ppplayermusic/ppplayer/releases'),
                    _buildActionButton(context, Icons.help_outline, l10n.support, 'https://ppplayer.com/support'),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      label: Text(l10n.license),
                      onPressed: () => _showProjectLicense(context),
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                    ActionChip(
                      label: Text(l10n.acknowledgments),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PPLicensePage(
                              applicationName: 'PPPlayer',
                              applicationVersion: version,
                              applicationLegalese: l10n.copyright(DateTime.now().year.toString()),
                            ),
                          ),
                        );
                      },
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.copyright(DateTime.now().year.toString()),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String text, String url) {
    return TextButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(text),
      onPressed: () => _launchUrl(url),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
