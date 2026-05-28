class SyncQueueItem {
  const SyncQueueItem({
    required this.entityId,
    required this.operation,
    required this.createdAt,
  });

  final String entityId;
  final String operation;
  final DateTime createdAt;
}
