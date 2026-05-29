import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Brightness brightness = Brightness.light;

  // Light accent colors (warm palette)
  static const _primaryLight = Color(0xFFD8A84E);
  static const _primarySoftLight = Color(0xFFF7E7C3);
  static const _mintLight = Color(0xFF9DBB9A);
  static const _sageLight = Color(0xFFC8D8BE);
  static const _pinkLight = Color(0xFFDFA7A0);
  static const _lavenderLight = Color(0xFFB9A7CF);
  static const _yellowLight = Color(0xFFEBC66F);

  // Dark accent colors (cool palette)
  static const _primaryDark = Color(0xFF7B9EC7);
  static const _primarySoftDark = Color(0xFF1A1F2E);
  static const _mintDark = Color(0xFF7BA89A);
  static const _sageDark = Color(0xFF8FA89A);
  static const _pinkDark = Color(0xFFB89A9E);
  static const _lavenderDark = Color(0xFF9B95B8);
  static const _yellowDark = Color(0xFFC9B86F);

  // Accent colors — theme-aware
  static Color get primary =>
      brightness == Brightness.dark ? _primaryDark : _primaryLight;
  static Color get primarySoft =>
      brightness == Brightness.dark ? _primarySoftDark : _primarySoftLight;
  static Color get mint =>
      brightness == Brightness.dark ? _mintDark : _mintLight;
  static Color get sage =>
      brightness == Brightness.dark ? _sageDark : _sageLight;
  static Color get pink =>
      brightness == Brightness.dark ? _pinkDark : _pinkLight;
  static Color get lavender =>
      brightness == Brightness.dark ? _lavenderDark : _lavenderLight;
  static Color get yellow =>
      brightness == Brightness.dark ? _yellowDark : _yellowLight;

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
  static const Color _backgroundDark = Color(0xFF0E1218);
  static const Color _surfaceDark = Color(0xFF1A1F28);
  static const Color _inkDark = Color(0xFFE0E4E8);
  static const Color _smokeDark = Color(0xFFB0B8C0);
  static const Color _textMainDark = Color(0xFFE0E4E8);
  static const Color _textMutedDark = Color(0xFF88909C);
  static const Color _borderDark = Color(0xFF2A3040);

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

  /// Background overlay for the calendar screen.
  /// Light: warm translucent beige. Dark: deep navy with high opacity.
  static Color get backgroundOverlay => brightness == Brightness.dark
      ? _primarySoftDark.withValues(alpha: .75)
      : _primarySoftLight.withValues(alpha: .32);

  /// Dim overlay for login screen backgrounds. Always dark.
  static Color get dimOverlay => brightness == Brightness.dark
      ? const Color(0xFF0A0D14).withValues(alpha: .72)
      : const Color(0xFF171D1B).withValues(alpha: .45);

  /// Semi-transparent app bar background. Always reads as dark.
  static Color get appBarBg => brightness == Brightness.dark
      ? const Color(0xFF0F141E).withValues(alpha: .8)
      : const Color(0xFF171D1B).withValues(alpha: .72);

  /// Highlight for today's row in weekly overview. Visible in both themes.
  static Color get todayHighlight => brightness == Brightness.dark
      ? _primaryDark.withValues(alpha: .28)
      : _primarySoftLight.withValues(alpha: .55);
}
