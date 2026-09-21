import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/search_provider.dart';
import '../../core/providers/recent_searches_provider.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'tactile_buttons.dart';

class SharedSearchInput extends ConsumerWidget {
  const SharedSearchInput({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasText = ref.watch(searchQueryProvider).isNotEmpty;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.scrim.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
        cursorColor: colorScheme.primary,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.whatDoYouWantToListenTo,
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            size: 22,
          ),
          suffixIcon: hasText
              ? TactileIconButton(
                  icon: Icons.close_rounded,
                  onTap: () {
                    controller.clear();
                    ref.read(searchQueryProvider.notifier).updateQuery('');
                  },
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                )
              : null,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          filled: false,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
        onChanged: (val) {
          ref.read(searchQueryProvider.notifier).updateQuery(val);
        },
        onSubmitted: (val) {
          if (val.trim().isNotEmpty) {
            ref.read(recentSearchesProvider.notifier).addSearch(val);
          }
        },
      ),
    );
  }
}
