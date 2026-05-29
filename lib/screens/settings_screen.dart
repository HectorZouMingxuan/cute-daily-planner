import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sync_metadata.dart';
import '../providers/sync_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/common/app_notification.dart';
import '../widgets/common/soft_card.dart';
import '../widgets/common/sync_status_badge.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SoftCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.calendar_month_rounded,
                      color: AppColors.primary, size: 26),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cute Daily Planner',
                          style: TextStyle(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                      Text('Version $_appVersion',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(
              themeMode == ThemeMode.dark ? 'Dark' : 'Light',
            ),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (_) async {
                await ref.read(themeModeProvider.notifier).toggle();
                if (!context.mounted) return;
                final isDark = ref.read(themeModeProvider) == ThemeMode.dark;
                AppNotification.info(
                  context,
                  isDark ? 'Dark mode enabled' : 'Light mode enabled',
                );
              },
            ),
          ),
          ListTile(
            title: const Text('Sync Status'),
            subtitle: Text(syncState.message),
            trailing: SyncStatusBadge(label: syncState.status.label),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About'),
            subtitle: const Text('Licenses and app info'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Cute Daily Planner',
              applicationVersion: _appVersion,
              applicationIcon: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_month_rounded,
                    color: AppColors.primary, size: 26),
              ),
              children: [
                const Text('Your cute daily planner and habit tracker.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
