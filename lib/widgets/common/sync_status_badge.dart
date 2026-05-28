import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'pastel_chip.dart';

class SyncStatusBadge extends StatelessWidget {
  const SyncStatusBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: PastelChip(
        label: label,
        color: AppColors.sage.withValues(alpha: .72),
      ),
    );
  }
}
