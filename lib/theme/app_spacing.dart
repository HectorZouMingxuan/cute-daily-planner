/// Consistent spacing scale used across the entire app.
///
/// Every margin / padding should reference one of these tokens so the
/// rhythm stays consistent no matter which screen or widget you're on.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Standard horizontal screen padding.
  static const double screenH = 16;

  /// Standard card internal padding.
  static const double card = 16;

  /// Gap between cards in a list / grid.
  static const double cardGap = 12;

  /// Section vertical gap.
  static const double section = 24;
}
