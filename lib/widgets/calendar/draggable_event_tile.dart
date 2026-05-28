import 'package:flutter/material.dart';

import '../../models/calendar_event.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/events/event_card.dart';

class DraggableEventTile extends StatelessWidget {
  const DraggableEventTile({
    required this.event,
    required this.onTap,
    super.key,
  });

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<CalendarEvent>(
      data: event,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 260,
          child: Transform.scale(
            scale: 1.03,
            child: EventCard(event: event, onTap: () {}),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: .45,
        child: EventCard(event: event, onTap: onTap),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: EventCard(event: event, onTap: onTap),
        ),
      ),
    );
  }
}
