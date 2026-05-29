import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'drag_handle.dart';

class FormShell extends StatelessWidget {
  const FormShell({
    required this.title,
    required this.child,
    this.actions,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.md),
          child,
          if (actions != null) ...[
            const SizedBox(height: AppSpacing.lg),
            actions!,
          ],
        ],
      ),
    );
  }
}
