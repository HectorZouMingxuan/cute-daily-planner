import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

final eventPalette = <Color>[
  AppColors.primary,
  AppColors.mint,
  AppColors.pink,
  AppColors.lavender,
  AppColors.yellow,
];

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    required this.selectedColor,
    required this.onChanged,
    super.key,
  });

  final Color selectedColor;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: eventPalette.map((color) {
        final selected = color.toARGB32() == selectedColor.toARGB32();
        return InkWell(
          customBorder: const CircleBorder(),
          onTap: () => onChanged(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.textMain : Colors.transparent,
                width: 2,
              ),
            ),
            child: selected
                ? const Icon(Icons.check_rounded, size: 18)
                : const SizedBox.shrink(),
          ),
        );
      }).toList(),
    );
  }
}
