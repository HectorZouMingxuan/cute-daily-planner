import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
