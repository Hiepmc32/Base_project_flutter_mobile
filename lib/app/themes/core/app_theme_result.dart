import 'package:flutter/material.dart';
import '../color/app_color.dart';
import '../common/font/base_font.dart';
import '../text_style/app_text_style.dart';
import 'app_theme.dart';

class AppThemeResult {
  AppThemeResult({
    required this.appTheme,
    required this.appColor,
    required this.appTextStyle,
    required this.appFont,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
  });

  final AppTheme appTheme;
  final AppColor appColor;
  final AppTextStyle appTextStyle;
  final BaseFont appFont;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
}
