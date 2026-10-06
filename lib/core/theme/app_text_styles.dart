import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// GrowOps brand typography.
///
/// Display (serif): used for screen titles + batch codes — matches prototype.
/// Body (sans): used for UI copy across the app.
abstract final class AppTextStyles {
  static String get displayFontFamily => GoogleFonts.sourceSerif4().fontFamily!;
  static String get bodyFontFamily => GoogleFonts.inter().fontFamily!;

  static TextStyle display({Color? color}) => GoogleFonts.sourceSerif4(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.ink,
        height: 1.15,
      );

  static TextStyle heading({Color? color}) => GoogleFonts.sourceSerif4(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.ink,
        height: 1.2,
      );

  static TextStyle title({Color? color}) => GoogleFonts.sourceSerif4(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.ink,
      );

  /// Batch codes like WC-C-001.
  static TextStyle batchCode({Color? color}) => GoogleFonts.sourceSerif4(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.ink,
        height: 1.2,
      );

  static TextStyle body({Color? color, FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight,
        color: color ?? AppColors.ink,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.muted,
      );

  static TextStyle label({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.ink,
      );

  static TextStyle section({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.muted,
      );

  static TextStyle button({Color? color, bool filled = true}) => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: color ?? (filled ? Colors.white : AppColors.ink),
      );

  static TextStyle chip({Color? color, bool small = false}) => GoogleFonts.inter(
        fontSize: small ? 11 : 12,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.ink,
      );
}
