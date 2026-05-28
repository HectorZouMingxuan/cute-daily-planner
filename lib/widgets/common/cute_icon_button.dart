import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CuteIconButton extends StatelessWidget {
  const CuteIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primarySoft,
        foregroundColor: AppColors.textMain,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
