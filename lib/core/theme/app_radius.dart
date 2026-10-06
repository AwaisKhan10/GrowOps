import 'package:flutter/material.dart';

/// Centralized border radius values.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 22;
  static const double xxl = 24;
  static const double pill = 28;

  static const card = BorderRadius.all(Radius.circular(xl));
  static const button = BorderRadius.all(Radius.circular(md));
  static const chip = BorderRadius.all(Radius.circular(lg));
  static const input = BorderRadius.all(Radius.circular(pill));
  static const bottomSheet = BorderRadius.vertical(top: Radius.circular(xxl));
  static const progress = BorderRadius.all(Radius.circular(sm));
}
