import 'dart:convert';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/settings_provider.dart';
import '../../core/theme/app_theme.dart';
import 'tactile_buttons.dart';
import 'premium_modals.dart';

void showEditProfileModal(
  BuildContext context,
  WidgetRef ref, {
  bool isDismissible = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final settingsNotifier = ref.read(settingsProvider.notifier);
  final settings = ref.read(settingsProvider);
  final nameController = TextEditingController(text: settings.userName);
  int selectedColorIndex = settings.userAvatarColorIndex;
  String? selectedAvatarBase64 = settings.userAvatarBase64;

  showPremiumModal(
    context: context,
    title: AppLocalizations.of(context)!.editProfile,
    isDismissible: isDismissible,
    child: StatefulBuilder(
      builder: (context, setState) {
        final themeColor = AppTheme.themeColors[settings.themeIndex];

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.themeColors[selectedColorIndex],
                      shape: BoxShape.circle,
                      image:
                          selectedAvatarBase64 != null &&
                              selectedAvatarBase64!.isNotEmpty
                          ? DecorationImage(
                              image: MemoryImage(
                                base64Decode(selectedAvatarBase64!),
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        selectedAvatarBase64 == null ||
                            selectedAvatarBase64!.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: TactileTap(
                      onTap: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          final bytes = await image.readAsBytes();
                          final base64String = base64Encode(bytes);
                          setState(() {
                            selectedAvatarBase64 = base64String;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: themeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'NAME',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterYourName,
                filled: true,
                fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: themeColor),
                ),
              ),
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            Text(
              'AVATAR COLOR',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 54,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppTheme.themeColors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final color = AppTheme.themeColors[index];
                  final isSelected = selectedColorIndex == index;
                  return TactileTap(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => selectedColorIndex = index);
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.onSurface
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: colorScheme.surface,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            TactileTap(
              onTap: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  settingsNotifier.setUserName(name);
                  settingsNotifier.setUserAvatarColorIndex(selectedColorIndex);
                  settingsNotifier.setUserAvatarBase64(selectedAvatarBase64);
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
