import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/daily_note.dart';
import '../../models/sync_metadata.dart';
import '../../theme/app_spacing.dart';
import '../common/soft_card.dart';

class DailyNoteEditor extends StatefulWidget {
  const DailyNoteEditor({
    required this.selectedDate,
    required this.onSave,
    super.key,
    this.note,
  });

  final DateTime selectedDate;
  final DailyNote? note;
  final ValueChanged<DailyNote> onSave;

  @override
  State<DailyNoteEditor> createState() => _DailyNoteEditorState();
}

class _DailyNoteEditorState extends State<DailyNoteEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void didUpdateWidget(covariant DailyNoteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note?.id != widget.note?.id) {
      _controller.text = widget.note?.content ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            minLines: 7,
            maxLines: 10,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Write a small note for today.',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Note'),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final now = DateTime.now();
    final existing = widget.note;
    final date = widget.selectedDate;
    widget.onSave(
      DailyNote(
        id: existing?.id ?? const Uuid().v4(),
        userId: existing?.userId ?? 'local-user',
        date: DateTime(date.year, date.month, date.day),
        content: _controller.text.trim(),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        syncStatus: SyncStatus.localOnly,
        version: (existing?.version ?? 0) + 1,
      ),
    );
  }
}
