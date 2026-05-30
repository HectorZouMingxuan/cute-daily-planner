import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens used across the entire app.
///
/// Every text widget should reference one of these styles so the
/// hierarchy stays consistent.
class AppTextStyles {
  AppTextStyles._();

  // ── Display ─────────────────────────────────────────────────────

  /// Large screen title — 28 sp / w900.
  static TextStyle get display => TextStyle(
        color: AppColors.textMain,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
        height: 1.15,
      );

  // ── Headings ────────────────────────────────────────────────────

  /// Section heading — 18 sp / w800.
  static TextStyle get heading => TextStyle(
        color: AppColors.textMain,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.25,
        height: 1.25,
      );

  /// Sub-section heading — 15 sp / w700.
  static TextStyle get subheading => TextStyle(
        color: AppColors.textMain,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  // ── Body ────────────────────────────────────────────────────────

  /// Standard body text — 14 sp / w500.
  static TextStyle get body => TextStyle(
        color: AppColors.textMain,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
      );

  /// Slightly smaller body for card interiors — 13 sp / w500.
  static TextStyle get bodySmall => TextStyle(
        color: AppColors.textMain,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // ── Captions & labels ───────────────────────────────────────────

  /// Muted caption — 12 sp / w600.
  static TextStyle get caption => TextStyle(
        color: AppColors.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  /// Even smaller label — 11 sp / w600.
  static TextStyle get micro => TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// Bold label used for chips and badges — 11 sp / w800.
  static TextStyle get chipLabel => TextStyle(
        color: AppColors.textMain,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        height: 1.2,
      );

  // ── Legacy aliases (keep existing code compiling) ───────────────

  static TextStyle get title => display;
  static TextStyle get sectionTitle => heading;
  static TextStyle get muted => caption;
}
