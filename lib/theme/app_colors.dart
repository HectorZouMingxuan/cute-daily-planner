import 'package:flutter/material.dart';

/// Central color system for the Cute Daily Planner.
///
/// Every color is brightness-aware so light and dark modes both feel
/// intentionally designed rather than mechanically inverted.
class AppColors {
  AppColors._();

  static Brightness brightness = Brightness.light;

  // ── Light palette (warm, soft, pastel) ──────────────────────────
  static const _primaryLight = Color(0xFFD4A84B);
  static const _primarySoftLight = Color(0xFFF9F0D7);
  static const _mintLight = Color(0xFF8AAF8A);
  static const _sageLight = Color(0xFFBCCCB4);
  static const _pinkLight = Color(0xFFDCA9A2);
  static const _lavenderLight = Color(0xFFB8A6CE);
  static const _yellowLight = Color(0xFFE8C36A);
  static const _peachLight = Color(0xFFF2C9A6);
  static const _skyLight = Color(0xFFA4C8E1);

  // ── Dark palette (cool, deep, calm) ─────────────────────────────
  static const _primaryDark = Color(0xFF8BADD4);
  static const _primarySoftDark = Color(0xFF1A2030);
  static const _mintDark = Color(0xFF7CA897);
  static const _sageDark = Color(0xFF8A9E8E);
  static const _pinkDark = Color(0xFFC4A0A4);
  static const _lavenderDark = Color(0xFF9F99BA);
  static const _yellowDark = Color(0xFFC9B872);
  static const _peachDark = Color(0xFFC4A892);
  static const _skyDark = Color(0xFF88A8C4);

  // ── Accent getters ──────────────────────────────────────────────

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

  static Color get peach =>
      brightness == Brightness.dark ? _peachDark : _peachLight;

  static Color get sky =>
      brightness == Brightness.dark ? _skyDark : _skyLight;

  static const danger = Color(0xFFC85B63);

  // ── Surface / text / border ─────────────────────────────────────

  static const _bgLight = Color(0xFFF6F4F0);
  static const _bgDark = Color(0xFF0C1018);

  static const _surfaceLight = Color(0xFFFFFFFF);
  static const _surfaceDark = Color(0xFF151B26);

  static const _surfaceAltLight = Color(0xFFFDF9F2);
  static const _surfaceAltDark = Color(0xFF1A2030);

  static const _inkLight = Color(0xFF1F2320);
  static const _inkDark = Color(0xFFE4E8EE);

  static const _smokeLight = Color(0xFF5A605A);
  static const _smokeDark = Color(0xFF98A0AC);

  static const _textMainLight = Color(0xFF222622);
  static const _textMainDark = Color(0xFFE4E8EE);

  static const _textMutedLight = Color(0xFF7A827A);
  static const _textMutedDark = Color(0xFF88909C);

  static const _borderLight = Color(0xFFE6DDCC);
  static const _borderDark = Color(0xFF2A3242);

  static Color get background =>
      brightness == Brightness.dark ? _bgDark : _bgLight;

  static Color get surface =>
      brightness == Brightness.dark ? _surfaceDark : _surfaceLight;

  static Color get surfaceAlt =>
      brightness == Brightness.dark ? _surfaceAltDark : _surfaceAltLight;

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

  /// Warm / cool overlay for the calendar background.
  static Color get backgroundOverlay => brightness == Brightness.dark
      ? _primarySoftDark.withValues(alpha: .78)
      : const Color(0xFFF9F0D7).withValues(alpha: .28);

  /// Dim overlay for login screens.
  static Color get dimOverlay => brightness == Brightness.dark
      ? const Color(0xFF080C14).withValues(alpha: .76)
      : const Color(0xFF1F2320).withValues(alpha: .42);

  /// Semi-transparent app bar.
  static Color get appBarBg => brightness == Brightness.dark
      ? const Color(0xFF0E1420).withValues(alpha: .85)
      : const Color(0xFF1F2320).withValues(alpha: .78);

  /// Today row highlight.
  static Color get todayHighlight => brightness == Brightness.dark
      ? _primaryDark.withValues(alpha: .24)
      : _primarySoftLight.withValues(alpha: .5);

  // ── Priority colors (theme-stable) ──────────────────────────────

  static const priorityHigh = Color(0xFFD4878A);
  static const priorityMedium = Color(0xFFD4B84B);
  static const priorityLow = Color(0xFF8AAF8A);

  // ── Mood colors ─────────────────────────────────────────────────

  static Color moodGreat(Color fallback) =>
      brightness == Brightness.dark ? const Color(0xFFC9B872) : const Color(0xFFE8C36A);
  static Color moodGood(Color fallback) =>
      brightness == Brightness.dark ? const Color(0xFF8BADD4) : const Color(0xFFA4C8E1);
  static Color moodOkay(Color fallback) =>
      brightness == Brightness.dark ? const Color(0xFF8A9E8E) : const Color(0xFFBCCCB4);
  static Color moodTired(Color fallback) =>
      brightness == Brightness.dark ? const Color(0xFF9F99BA) : const Color(0xFFB8A6CE);
  static Color moodBad(Color fallback) =>
      brightness == Brightness.dark ? const Color(0xFFC4A0A4) : const Color(0xFFDCA9A2);
}
