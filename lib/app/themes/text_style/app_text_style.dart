import 'package:flutter/material.dart';

import '../common/font/base_font.dart';
import '../color/app_color.dart';
import '../size/text_size_manager.dart';

class AppTextStyle {
  AppTextStyle({required this.color, required this.baseFont});

  final AppColor color;
  final BaseFont baseFont;

  TextStyle extraBold({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        fontFamily: baseFont.fontExtraBold,
        fontWeight: FontWeight.w800,
        size: size,
        color: color,
        backgroundColor: backgroundColor,
      );

  TextStyle bold({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        fontFamily: baseFont.fontBold,
        fontWeight: FontWeight.w700,
        size: size,
        color: color,
        backgroundColor: backgroundColor,
      );

  TextStyle semiBold({
    double? size,
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
  }) => custom(
    fontFamily: baseFont.fontSemiBold,
    fontWeight: FontWeight.w600,
    size: size,
    color: color,
    decoration: decoration,
    backgroundColor: backgroundColor,
  );

  TextStyle medium({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        fontFamily: baseFont.fontMedium,
        fontWeight: FontWeight.w500,
        size: size,
        color: color,
        backgroundColor: backgroundColor,
      );

  TextStyle regular({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        fontFamily: baseFont.fontRegular,
        size: size,
        color: color,
        fontWeight: FontWeight.w400,
        backgroundColor: backgroundColor,
      );

  TextStyle get displayLarge => bold(size: 32);

  TextStyle get displayMedium => bold(size: 28);

  TextStyle get displaySmall => semiBold(size: 24);

  TextStyle get headlineLarge => bold(size: 22);

  TextStyle get headlineMedium => semiBold(size: 20);

  TextStyle get headlineSmall => semiBold(size: 18);

  TextStyle get titleLarge => semiBold(size: 16);

  TextStyle get titleMedium => medium(size: 15);

  TextStyle get titleSmall => medium(size: 14);

  TextStyle get bodyLarge => regular(size: 16);

  TextStyle get bodyMedium => regular(size: 14);

  TextStyle get bodySmall => regular(size: 12);

  TextStyle get labelLarge => semiBold(size: 14);

  TextStyle get labelMedium => medium(size: 12);

  TextStyle get labelSmall => medium(size: 11);

  TextTheme textTheme() {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: color.textPrimary),
      displayMedium: displayMedium.copyWith(color: color.textPrimary),
      displaySmall: displaySmall.copyWith(color: color.textPrimary),
      headlineLarge: headlineLarge.copyWith(color: color.textPrimary),
      headlineMedium: headlineMedium.copyWith(color: color.textPrimary),
      headlineSmall: headlineSmall.copyWith(color: color.textPrimary),
      titleLarge: titleLarge.copyWith(color: color.textPrimary),
      titleMedium: titleMedium.copyWith(color: color.textPrimary),
      titleSmall: titleSmall.copyWith(color: color.textSecondary),
      bodyLarge: bodyLarge.copyWith(color: color.textPrimary),
      bodyMedium: bodyMedium.copyWith(color: color.textSecondary),
      bodySmall: bodySmall.copyWith(color: color.textSecondary),
      labelLarge: labelLarge.copyWith(color: color.textPrimary),
      labelMedium: labelMedium.copyWith(color: color.textSecondary),
      labelSmall: labelSmall.copyWith(color: color.textDisabled),
    );
  }

  TextStyle custom({
    double? size,
    Color? color,
    Color? backgroundColor,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    String? fontFamily,
    TextDecoration? decoration,
    TextDecorationStyle? decorationStyle,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? getFontFamily(fontWeight),
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      decorationStyle: decorationStyle,
      backgroundColor: backgroundColor,
      fontSize: (size ?? 13) * TextSizeManager().textScaleFactor,
      color: color ?? this.color.textPrimary,
    );
  }

  String? getFontFamily(FontWeight? fontWeight) {
    if (fontWeight == null) {
      return baseFont.fontRegular;
    }
    switch (fontWeight) {
      case FontWeight.w100:
      case FontWeight.w200:
      case FontWeight.w300:
      case FontWeight.w400:
        return baseFont.fontRegular;

      case FontWeight.w500:
        return baseFont.fontMedium;

      case FontWeight.w600:
        return baseFont.fontSemiBold;
      case FontWeight.w700:
        return baseFont.fontBold;

      case FontWeight.w800:
      case FontWeight.w900:
        return baseFont.fontExtraBold;
      default:
        return baseFont.fontRegular;
    }
  }
}
