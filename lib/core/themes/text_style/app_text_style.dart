// import 'dart:ui';

// import 'package:flutter_mobile/global/font_const.dart';
// import 'package:flutter_mobile/import.dart';
import 'package:flutter/material.dart';
import '../core/app_theme_manager.dart';
import '../size/text_size_manager.dart';

class AppTextStyle {
  TextStyle extraBold({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        // fontFamily: FontConst.fontExtraBold,
        fontFamily: AppThemeManger().baseFont.fontExtraBold,
        size: size,
        color: color,
        backgroundColor: backgroundColor,
      );

  TextStyle bold({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        fontFamily: AppThemeManger().baseFont.fontBold,
        // fontFamily: FontConst.fontBold,
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
    // fontFamily: FontConst.fontSemiBold,
    fontFamily: AppThemeManger().baseFont.fontSemiBold,
    size: size,
    color: color,
    decoration: decoration,
    backgroundColor: backgroundColor,
  );

  TextStyle medium({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        // fontFamily: FontConst.fontMedium,
        fontFamily: AppThemeManger().baseFont.fontMedium,
        size: size,
        color: color,
        backgroundColor: backgroundColor,
      );

  TextStyle regular({double? size, Color? color, Color? backgroundColor}) =>
      custom(
        // fontFamily: FontConst.fontRegular,
        fontFamily: AppThemeManger().baseFont.fontRegular,
        size: size,
        color: color,
        // fontWeight: FontWeight.w400,
        backgroundColor: backgroundColor,
      );

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
      color: color ?? AppThemeManger().theme.primary,
    );
  }

  String? getFontFamily(FontWeight? fontWeight) {
    // return null;

    if (fontWeight == null) {
      return AppThemeManger().baseFont.fontRegular;
    }
    switch (fontWeight) {
      case FontWeight.w100:
      case FontWeight.w200:
      case FontWeight.w300:
      case FontWeight.w400:
        return AppThemeManger().baseFont.fontRegular;

      case FontWeight.w500:
        return AppThemeManger().baseFont.fontMedium;

      case FontWeight.w600:
        return AppThemeManger().baseFont.fontSemiBold;
      case FontWeight.w700:
        return AppThemeManger().baseFont.fontBold;

      case FontWeight.w800:
      case FontWeight.w900:
        return AppThemeManger().baseFont.fontExtraBold;
      default:
        return AppThemeManger().baseFont.fontRegular;
    }
  }
}
