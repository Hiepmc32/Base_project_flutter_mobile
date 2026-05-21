import 'package:flutter/material.dart';
import '../app_theme/app_theme_dark.dart';
import '../app_theme/app_theme_light.dart';
import '../color/app_color.dart';
import 'font/base_font.dart';
import '../core/app_theme_result.dart';
import '../text_style/app_text_style.dart';

enum AppThemeType {
  dark,
  light;

  AppThemeResult appThemeMobile({required BaseFont appFont}) {
    switch (this) {
      case AppThemeType.dark:
        final AppColor appColor = AppColorDark();
        final AppTextStyle appTextStyle = AppTextStyle(
          color: appColor,
          baseFont: appFont,
        );

        return AppThemeResult(
          appTheme: AppThemeDark(
            color: appColor,
            textStyle: appTextStyle,
            baseFont: appFont,
          ),
          appColor: appColor,
          appTextStyle: appTextStyle,
          appFont: appFont,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        );

      case AppThemeType.light:
        final AppColor appColor = AppColorLight();
        final AppTextStyle appTextStyle = AppTextStyle(
          color: appColor,
          baseFont: appFont,
        );

        return AppThemeResult(
          appTheme: AppThemeLight(
            color: appColor,
            textStyle: appTextStyle,
            baseFont: appFont,
          ),
          appColor: appColor,
          appTextStyle: appTextStyle,
          appFont: appFont,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        );
    }
  }
}
