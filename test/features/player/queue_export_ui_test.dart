import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/core/local_library/local_library_service.dart';
import 'package:ppplayer/core/local_library/m3u_handler.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ppplayer/l10n/app_localizations.dart';

import 'queue_export_ui_test.mocks.dart';

@GenerateMocks([LocalLibraryService])
void main() {
  late MockLocalLibraryService mockService;

  setUp(() {
    mockService = MockLocalLibraryService();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        localLibraryServiceProvider.overrideWithValue(mockService),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton.icon(
                key: const ValueKey('export_queue_button'),
                onPressed: () async {
                   try {
                     final result = await ProviderScope.containerOf(context, listen: false)
                         .read(localLibraryServiceProvider)
                         .exportQueue([]);
                     if (context.mounted) {
                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Export cancelled.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Exported playlist. Skipped ${result.skippedCount} items.')),
                          );
                        }
                     }
                   } catch (e) {
                     if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Export failed: $e')),
                        );
                     }
                   }
                },
                icon: const Icon(Icons.download_rounded, size: 20),
                label: const Text('Export Playlist'),
              );
            }
          ),
        ),
      ),
    );
  }

  testWidgets('Export queue cancellation shows cancelled snackbar', (WidgetTester tester) async {
    when(mockService.exportQueue(any)).thenAnswer((_) async => null);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byKey(const ValueKey('export_queue_button')));
    await tester.pumpAndSettle();

    expect(find.text('Export cancelled.'), findsOneWidget);
  });

  testWidgets('Export queue success shows skipped count snackbar', (WidgetTester tester) async {
    when(mockService.exportQueue(any)).thenAnswer((_) async => M3uExportResult('content', 2));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byKey(const ValueKey('export_queue_button')));
    await tester.pumpAndSettle();

    expect(find.text('Exported playlist. Skipped 2 items.'), findsOneWidget);
  });

  testWidgets('Export queue failure shows error snackbar', (WidgetTester tester) async {
    when(mockService.exportQueue(any)).thenThrow(Exception('Disk full'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byKey(const ValueKey('export_queue_button')));
    await tester.pumpAndSettle();

    expect(find.text('Export failed: Exception: Disk full'), findsOneWidget);
  });
}
