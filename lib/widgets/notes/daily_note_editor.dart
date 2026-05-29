import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/daily_note.dart';
import '../../models/sync_metadata.dart';
import '../../theme/app_colors.dart';
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
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note?.content ?? '');
    _controller.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant DailyNoteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note?.id != widget.note?.id) {
      _controller.text = widget.note?.content ?? '';
      _saved = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _wordCount => _controller.text.trim().isEmpty
      ? 0
      : _controller.text.trim().split(RegExp(r'\s+')).length;

  @override
  Widget build(BuildContext context) {
    final lastEdited = widget.note?.updatedAt;
    final lastEditedStr = lastEdited != null
        ? 'Last edited ${DateFormat('MMM d, HH:mm').format(lastEdited)}'
        : null;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            minLines: 6,
            maxLines: 10,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Write a small note for today...',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '$_wordCount word${_wordCount == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (lastEditedStr != null && !_saved) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    lastEditedStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              if (_saved)
                const Text(
                  'Saved!',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mint,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('Save'),
              ),
            ],
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
    setState(() => _saved = true);
  }
}
