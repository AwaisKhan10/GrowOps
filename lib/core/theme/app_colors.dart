import 'package:flutter/material.dart';

/// Centralized color tokens for GrowOps Go.
///
/// Change branding colors here to update the entire application.
abstract final class AppColors {
  // Brand
  static const cream = Color(0xFFF7F4EF);
  static const forest = Color(0xFF1F4A3A);
  static const forestSoft = Color(0xFF2F5D4A);
  static const mint = Color(0xFFDCE8E1);

  // Surfaces
  static const card = Color(0xFFFFFFFF);
  static const line = Color(0xFFE7E2D9);
  static const inputFill = Color(0xFFF3EFE8);
  static const softButtonUnfilled = Color(0xFFF1EEE8);
  static const authDemoBox = Color(0xFFF3F6F3);

  // Text
  static const ink = Color(0xFF1C1C1A);
  static const muted = Color(0xFF6B726C);
  static const hint = Color(0xFF8B938D);
  static const darkHint = Color(0xFF8A9A92);

  // Status
  static const success = Color(0xFFDDEBD8);
  static const successInk = Color(0xFF1F4A3A);
  static const warning = Color(0xFFF3E0D0);
  static const warningInk = Color(0xFF8A5A22);
  static const error = Color(0xFFF3E0D0);
  static const alertIcon = Color(0xFFC47B2B);

  // Stage chips
  static const chipFlower = Color(0xFFF3E6F8);
  static const chipFlowerInk = Color(0xFF7A4A8A);
  static const chipVeg = Color(0xFFDCEFDD);
  static const chipVegInk = Color(0xFF3D6B42);
  static const chipDry = Color(0xFFF6E6C8);
  static const chipDryInk = Color(0xFF8A5A22);
  static const chipSeed = Color(0xFFE3F3D8);
  static const chipSeedInk = Color(0xFF4A7A32);
  static const chipHarvest = Color(0xFFE8DCCF);
  static const chipHarvestInk = Color(0xFF6A4A2A);
  static const chipCuring = Color(0xFFE4D7C8);
  static const chipCuringInk = Color(0xFF6A5038);
  static const chipPackaged = Color(0xFFDCE4F0);
  static const chipPackagedInk = Color(0xFF3A5278);

  // Misc
  static const photoPlaceholder = Color(0xFF9AD4E6);

  // Dark theme surfaces
  static const darkBackground = Color(0xFF121816);
  static const darkSurface = Color(0xFF1C2420);
  static const darkCard = Color(0xFF243028);
  static const darkLine = Color(0xFF3A4540);
  static const darkMuted = Color(0xFF9AA39C);
  static const darkInk = Color(0xFFF2F4F2);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color inkOf(BuildContext context) =>
      isDark(context) ? darkInk : ink;

  static Color mutedOf(BuildContext context) =>
      isDark(context) ? darkMuted : muted;

  static Color cardOf(BuildContext context) =>
      isDark(context) ? darkCard : card;

  static Color lineOf(BuildContext context) =>
      isDark(context) ? darkLine : line;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? darkSurface : cream;

  static Color softButtonOf(BuildContext context) =>
      isDark(context) ? darkSurface : softButtonUnfilled;

  /// Brand green that stays readable on both light cards and dark surfaces.
  static const darkEmphasis = Color(0xFFC5E0D4);

  static Color emphasisOf(BuildContext context) =>
      isDark(context) ? darkEmphasis : forest;

  /// Unselected chip / pill fill.
  static Color chipFillOf(BuildContext context) =>
      isDark(context) ? const Color(0xFF314038) : softButtonUnfilled;
}

/// Legacy alias — existing screens import [GoColors].
typedef GoColors = AppColors;
