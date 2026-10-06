import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Builds light and dark [ThemeData] for the application.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final background = isLight ? AppColors.cream : AppColors.darkBackground;
    final surface = isLight ? AppColors.cream : AppColors.darkSurface;
    final card = isLight ? AppColors.card : AppColors.darkCard;
    final ink = isLight ? AppColors.ink : Colors.white;
    final muted = isLight ? AppColors.muted : AppColors.darkMuted;
    final line = isLight ? AppColors.line : AppColors.darkLine;
    final inputFill =
        isLight ? AppColors.inputFill : AppColors.darkCard;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        brightness: brightness,
        surface: surface,
        primary: AppColors.forest,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: AppTextStyles.bodyFontFamily,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display(color: ink),
        headlineMedium: AppTextStyles.heading(color: ink),
        titleMedium: AppTextStyles.title(color: ink),
        bodyMedium: AppTextStyles.body(color: ink),
        bodySmall: AppTextStyles.bodySmall(color: muted),
        labelLarge: AppTextStyles.button(color: Colors.white, filled: true),
        labelSmall: AppTextStyles.label(color: muted),
      ),
      dividerColor: line,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: AppColors.mint,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTextStyles.label(
            color: selected ? AppColors.forest : muted,
          );
        }),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: background),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.forest,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: line),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.forest,
        labelStyle: AppTextStyles.chip(color: ink),
        secondaryLabelStyle: AppTextStyles.chip(color: Colors.white),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading(color: ink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        hintStyle: AppTextStyles.body(
          color: isLight ? AppColors.hint : AppColors.darkHint,
        ),
        labelStyle: AppTextStyles.bodySmall(
          color: isLight ? AppColors.hint : AppColors.darkHint,
        ),
        floatingLabelStyle: AppTextStyles.bodySmall(
          color: isLight ? AppColors.muted : AppColors.darkMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.forest.withValues(alpha: 0.45)),
        ),
        contentPadding: AppSpacing.inputPadding,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.forest,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: AppSpacing.buttonPadding,
          textStyle: AppTextStyles.button(filled: true),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.forest,
        titleTextStyle: AppTextStyles.body(color: ink, weight: FontWeight.w600),
      ),
    );
  }
}

/// Legacy helper used by existing code during migration.
ThemeData buildGoTheme() => AppTheme.light;
