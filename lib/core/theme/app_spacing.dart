import 'package:flutter/material.dart';

/// Consistent spacing scale for layout padding and gaps.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 28;

  /// Bottom padding for scrollable screens above FAB + bottom nav.
  static const double screenBottomInset = 100;

  static const screenPadding = EdgeInsets.fromLTRB(lg, sm, lg, screenBottomInset);
  static const screenPaddingCompact = EdgeInsets.fromLTRB(lg, sm, lg, lg);
  static const headerPadding = EdgeInsets.fromLTRB(sm, sm, md, sm);
  static const sectionLabelPadding = EdgeInsets.fromLTRB(xs, lg, xs, sm);
  static const cardPadding = EdgeInsets.all(lg);
  static const inputPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 14);
  static const buttonPadding = EdgeInsets.symmetric(horizontal: xl, vertical: 14);
}
