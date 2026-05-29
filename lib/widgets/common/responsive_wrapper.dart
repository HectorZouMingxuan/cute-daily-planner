import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({required this.child, super.key});

  static const maxContentWidth = 640.0;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }
}
