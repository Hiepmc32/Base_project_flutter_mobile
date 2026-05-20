import 'package:flutter/material.dart';
import '../common/font/base_font.dart';
import 'app_theme.dart';

class AppThemeResult {
  AppThemeResult({
    required this.appTheme,
    required this.appFont,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
  });

  final AppTheme appTheme;
  final BaseFont appFont;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
}
