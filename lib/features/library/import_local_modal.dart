import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/premium_modals.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/local_library/local_library_service.dart';

void showImportLocalModal(BuildContext context, WidgetRef ref) {
  showPremiumModal<void>(
    context: context,
    title: 'Import Local Music',
    child: Builder(
      builder: (dialogContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TactileTap(
            onTap: () {
              Navigator.pop(dialogContext);
              ref.read(localLibraryServiceProvider).importFiles();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Row(
                children: [
                  Icon(Icons.audio_file, color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 16),
                  Text('Import Audio Files', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TactileTap(
            onTap: () {
              Navigator.pop(dialogContext);
              ref.read(localLibraryServiceProvider).importFolder();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Row(
                children: [
                  Icon(Icons.folder, color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 16),
                  Text('Import Folder', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}
