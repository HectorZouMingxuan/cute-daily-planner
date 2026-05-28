import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sync_metadata.dart';
import '../providers/sync_provider.dart';
import '../theme/app_spacing.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/soft_card.dart';
import '../widgets/common/sync_status_badge.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          ListTile(
            title: const Text('Sync Status'),
            subtitle: Text(syncState.message),
            trailing: SyncStatusBadge(label: syncState.status.label),
          ),
          const SizedBox(height: AppSpacing.md),
          const SoftCard(
            child: EmptyState(
              icon: Icons.info_outline_rounded,
              title: 'Firebase setup needed',
              message:
                  'Local calendar works now. Add Firebase config to enable cloud sync.',
            ),
          ),
        ],
      ),
    );
  }
}
