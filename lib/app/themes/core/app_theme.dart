import 'package:flutter/material.dart';

import '../common/font/base_font.dart';
import '../color/app_color.dart';
import '../text_style/app_text_style.dart';

abstract class AppTheme extends AppColor {
  AppTheme({
    required this.color,
    required this.textStyle,
    required this.baseFont,
  });

  final AppColor color;
  final AppTextStyle textStyle;
  final BaseFont baseFont;

  ThemeData get theme;

  @override
  Color get primary => color.primary;

  @override
  Color get onPrimary => color.onPrimary;

  @override
  Color get secondary => color.secondary;

  @override
  Color get onSecondary => color.onSecondary;

  @override
  Color get background => color.background;

  @override
  Color get surface => color.surface;

  @override
  Color get onSurface => color.onSurface;

  @override
  Color get card => color.card;

  @override
  Color get divider => color.divider;

  @override
  Color get textPrimary => color.textPrimary;

  @override
  Color get textSecondary => color.textSecondary;

  @override
  Color get textDisabled => color.textDisabled;

  @override
  Color get icon => color.icon;

  @override
  Color get disabled => color.disabled;

  @override
  Color get error => color.error;

  @override
  Color get onError => color.onError;

  @override
  Color get statusBarColor => color.statusBarColor;

  @override
  Color get success => color.success;

  @override
  Color get warning => color.warning;

  @override
  Color get info => color.info;

  @override
  Color get appBarBackground => color.appBarBackground;

  @override
  Color get appBarForeground => color.appBarForeground;
}
