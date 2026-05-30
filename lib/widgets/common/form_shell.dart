import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'drag_handle.dart';

/// Consistent wrapper for every bottom-sheet form in the app.
///
/// The entire shell — header, fields, and actions — lives inside a
/// [SingleChildScrollView] so forms never overflow on small screens.
/// Keyboard insets are automatically accounted for.
class FormShell extends StatelessWidget {
  const FormShell({
    required this.title,
    required this.child,
    super.key,
    this.actions,
  });

  final String title;
  final Widget child;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DragHandle(),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.display),
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
