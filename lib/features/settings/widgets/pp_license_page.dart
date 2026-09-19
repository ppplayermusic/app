import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PPLicensePage extends StatefulWidget {
  final String applicationName;
  final String applicationVersion;
  final String applicationLegalese;

  const PPLicensePage({
    super.key,
    required this.applicationName,
    required this.applicationVersion,
    required this.applicationLegalese,
  });

  @override
  State<PPLicensePage> createState() => _PPLicensePageState();
}

class _PPLicensePageState extends State<PPLicensePage> {
  final Map<String, List<LicenseEntry>> _licensesByPackage = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLicenses();
  }

  Future<void> _loadLicenses() async {
    final stream = LicenseRegistry.licenses;
    await for (final license in stream) {
      for (final package in license.packages) {
        _licensesByPackage.putIfAbsent(package, () => []).add(license);
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildLicenseText(LicenseEntry entry, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entry.paragraphs.map((p) {
          final isCentered = p.indent == LicenseParagraph.centeredIndent;
          final leftPadding = isCentered
              ? 0.0
              : (p.indent > 0 ? p.indent * 16.0 : 0.0);

          return Padding(
            padding: EdgeInsets.only(left: leftPadding, bottom: 8.0),
            child: Text(
              p.text,
              textAlign: isCentered ? TextAlign.center : TextAlign.left,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final packages = _licensesByPackage.keys.toList()..sort();
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          localizations.licensesPageTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${widget.applicationName} ${widget.applicationVersion}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.applicationLegalese,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      final package = packages[index];
                      final licenses = _licensesByPackage[package]!;

                      return ExpansionTile(
                        title: Text(
                          package,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${licenses.length} license(s)',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        collapsedIconColor: theme.colorScheme.onSurfaceVariant,
                        iconColor: theme.colorScheme.primary,
                        children: [
                          Container(
                            width: double.infinity,
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: licenses
                                  .map(
                                    (entry) => _buildLicenseText(entry, theme),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
