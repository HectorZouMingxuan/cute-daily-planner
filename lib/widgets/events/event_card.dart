import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/calendar_event.dart';
import '../../models/sync_metadata.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../common/sync_status_badge.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, required this.onTap, super.key});

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeLabel = event.isAllDay
        ? 'All day'
        : '${DateFormat.jm().format(event.startAt)} - ${DateFormat.jm().format(event.endAt)}';

    final durationLabel = event.isAllDay
        ? null
        : _formatDuration(event.endAt.difference(event.startAt));

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(event.color),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          timeLabel,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (durationLabel != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            durationLabel,
                            style: TextStyle(
                              color: AppColors.textMuted.withValues(alpha: .7),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (event.recurrenceRule.repeats) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.recurrenceRule.label,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    SyncStatusBadge(label: event.syncStatus.label),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
  if (hours > 0) return '${hours}h';
  if (minutes > 0) return '${minutes}m';
  return '';
}
