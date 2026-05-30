import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// Opens a themed modal bottom sheet.
///
/// On wide screens the sheet is centered with a max-width so it never
/// stretches edge-to-edge.  On narrow screens it uses the full width.
/// Height is constrained so the sheet never covers the full viewport.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final isWide = screenWidth > 600;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(
      maxHeight: screenHeight * .88,
      maxWidth: isWide ? 600 : screenWidth,
    ),
    builder: (context) => isWide
        ? Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: _SheetSurface(child: child),
            ),
          )
        : _SheetSurface(child: child),
  );
}

/// The rounded surface that sits inside every bottom sheet.
class _SheetSurface extends StatelessWidget {
  const _SheetSurface({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
