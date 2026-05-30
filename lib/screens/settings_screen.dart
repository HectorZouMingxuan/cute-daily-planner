import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sync_metadata.dart';
import '../providers/sync_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../widgets/common/app_notification.dart';
import '../widgets/common/planner_card.dart';
import '../widgets/common/sync_status_badge.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _appVersion = '4.5.0';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            children: [
              // App info card
              PlannerCard(
                padding: const EdgeInsets.all(AppSpacing.card),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cute Daily Planner',
                            style: TextStyle(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Version $_appVersion',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // Appearance section
              _SectionLabel('Appearance'),
              PlannerCard(
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    isDark ? 'Cool night palette' : 'Warm light palette',
                    style: const TextStyle(fontSize: 12),
                  ),
                  secondary: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: isDark ? AppColors.lavender : AppColors.yellow,
                  ),
                  value: isDark,
                  onChanged: (_) async {
                    await ref.read(themeModeProvider.notifier).toggle();
                    if (!context.mounted) return;
                    final nowDark =
                        ref.read(themeModeProvider) == ThemeMode.dark;
                    AppNotification.info(
                      context,
                      nowDark ? 'Dark mode enabled' : 'Light mode enabled',
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // Sync section
              _SectionLabel('Data'),
              PlannerCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  title: const Text(
                    'Sync Status',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(syncState.message,
                      style: const TextStyle(fontSize: 12)),
                  trailing:
                      SyncStatusBadge(label: syncState.status.label),
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // About section
              _SectionLabel('Info'),
              PlannerCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text(
                    'About',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Licenses and app info',
                      style: TextStyle(fontSize: 12)),
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
                    children: const [
                      Text('Your cute daily planner and habit tracker.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: .8,
        ),
      ),
    );
  }
}
