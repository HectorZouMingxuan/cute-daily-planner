import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Brightness brightness = Brightness.light;

  // Accent colors (same across themes)
  static const primary = Color(0xFFD8A84E);
  static const primarySoft = Color(0xFFF7E7C3);
  static const mint = Color(0xFF9DBB9A);
  static const sage = Color(0xFFC8D8BE);
  static const pink = Color(0xFFDFA7A0);
  static const lavender = Color(0xFFB9A7CF);
  static const yellow = Color(0xFFEBC66F);
  static const danger = Color(0xFFC85B63);

  // Light-only
  static const Color _backgroundLight = Color(0xFFF8FAFC);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _inkLight = Color(0xFF171D1B);
  static const Color _smokeLight = Color(0xFF2D332F);
  static const Color _textMainLight = Color(0xFF202820);
  static const Color _textMutedLight = Color(0xFF6F786F);
  static const Color _borderLight = Color(0xFFE8DECC);

  // Dark-only
  static const Color _backgroundDark = Color(0xFF101412);
  static const Color _surfaceDark = Color(0xFF1C211F);
  static const Color _inkDark = Color(0xFFE0E4DD);
  static const Color _smokeDark = Color(0xFFB0B8B0);
  static const Color _textMainDark = Color(0xFFE0E4DD);
  static const Color _textMutedDark = Color(0xFF949C94);
  static const Color _borderDark = Color(0xFF2A302D);

  static Color get background =>
      brightness == Brightness.dark ? _backgroundDark : _backgroundLight;
  static Color get surface =>
      brightness == Brightness.dark ? _surfaceDark : _surfaceLight;
  static Color get ink =>
      brightness == Brightness.dark ? _inkDark : _inkLight;
  static Color get smoke =>
      brightness == Brightness.dark ? _smokeDark : _smokeLight;
  static Color get textMain =>
      brightness == Brightness.dark ? _textMainDark : _textMainLight;
  static Color get textMuted =>
      brightness == Brightness.dark ? _textMutedDark : _textMutedLight;
  static Color get border =>
      brightness == Brightness.dark ? _borderDark : _borderLight;
}
