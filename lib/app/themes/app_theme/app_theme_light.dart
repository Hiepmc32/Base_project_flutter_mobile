import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class AppThemeLight extends AppTheme {
  AppThemeLight({
    required super.color,
    required super.textStyle,
    required super.baseFont,
  });

  @override
  ThemeData get theme {
    final TextTheme textTheme = textStyle.textTheme();

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
      primaryColor: primary,
      fontFamily: baseFont.fontFamily,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: appBarForeground),
        iconTheme: IconThemeData(color: appBarForeground),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      iconTheme: IconThemeData(color: icon),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected) ? primary : icon,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((
          Set<WidgetState> states,
        ) {
          return textStyle.labelMedium.copyWith(
            color:
                states.contains(WidgetState.selected) ? primary : textSecondary,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          textStyle: textStyle.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }
}
