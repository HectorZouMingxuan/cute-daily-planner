import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../common/soft_card.dart';

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({required this.events, super.key});

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));

    final upcoming = events
        .where((e) {
          final d = DateTime(e.startAt.year, e.startAt.month, e.startAt.day);
          return d.isAfter(today) && d.isBefore(nextWeek.add(const Duration(days: 1)));
        })
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    if (upcoming.isEmpty) return const SizedBox.shrink();

    final top3 = upcoming.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSpacing.sm),
        SoftCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: top3.map((event) {
              final dayDiff = DateTime(event.startAt.year, event.startAt.month, event.startAt.day)
                  .difference(today)
                  .inDays;
              final dayLabel = dayDiff == 0
                  ? 'Today'
                  : dayDiff == 1
                      ? 'Tomorrow'
                      : DateFormat('EEE, MMM d').format(event.startAt);
              final timeLabel = event.isAllDay ? 'All day' : DateFormat('HH:mm').format(event.startAt);
              final durationLabel = event.isAllDay
                  ? null
                  : _formatDuration(event.endAt.difference(event.startAt));
              final subtitle = durationLabel != null
                  ? '$dayLabel  ·  $timeLabel  ·  $durationLabel'
                  : '$dayLabel  ·  $timeLabel';
              final color = Color(event.color);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMain),
                          ),
                          Text(
                            subtitle,
                            style:  TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
