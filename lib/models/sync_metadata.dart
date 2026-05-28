enum SyncStatus { localOnly, syncing, synced, syncFailed }

extension SyncStatusLabel on SyncStatus {
  String get label {
    return switch (this) {
      SyncStatus.localOnly => 'Local only',
      SyncStatus.syncing => 'Syncing',
      SyncStatus.synced => 'Synced',
      SyncStatus.syncFailed => 'Sync failed',
    };
  }
}
