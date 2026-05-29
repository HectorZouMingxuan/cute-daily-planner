import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import 'auth_provider.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _updateBrightness(mode);
  }

  void applyPreference(bool darkModeEnabled) {
    setThemeMode(darkModeEnabled ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(newMode);

    final repo = ref.read(authRepositoryProvider);
    final userId = repo.currentUser?.id;
    if (userId != null) {
      await repo.saveDarkModePreference(
        userId: userId,
        darkModeEnabled: !isDark,
      );
    }
  }

  void _updateBrightness(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        AppColors.brightness = Brightness.light;
      case ThemeMode.dark:
        AppColors.brightness = Brightness.dark;
      case ThemeMode.system:
        AppColors.brightness = Brightness.light;
    }
  }
}
