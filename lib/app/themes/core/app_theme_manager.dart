import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/extensions/utils.dart';
import '../../../core/constants/app_const.dart';
import '../app_theme/app_theme_dark.dart';
import '../color/app_color.dart';
import '../common/app_theme_type.dart';
import '../common/font/base_font.dart';
import '../text_style/app_text_style.dart';
import 'app_theme.dart';
import 'app_theme_result.dart';

class AppThemeManger extends ChangeNotifier {
  factory AppThemeManger({SharedPreferences? preferences}) {
    if (preferences != null) {
      _singleton._preferences = preferences;
      _singleton._initThemeModeFromStorage();
    }
    return _singleton;
  }

  AppThemeManger._internal() {
    _initThemeModeFromStorage();
  }

  BaseFont baseFont = BaseFont();
  AppColor color = AppColorDark();
  late AppTextStyle textStyle = AppTextStyle(color: color, baseFont: baseFont);
  late AppTheme theme = AppThemeDark(
    color: color,
    textStyle: textStyle,
    baseFont: baseFont,
  );

  static final AppThemeManger _singleton = AppThemeManger._internal();

  AppThemeType _appThemeType = AppThemeType.dark;
  SharedPreferences? _preferences;

  AppThemeType get appTheme => _appThemeType;

  ThemeData get themeData => theme.theme;

  Future<void> changeAppTheme(AppThemeType type) async {
    if (_appThemeType == type) {
      return;
    }

    _appThemeType = type;
    updateTheme();
    notifyListeners();

    final SharedPreferences? preferences = _preferences;
    if (preferences != null) {
      await preferences.setString(AppConst.keyThemeMode, type.toString());
    }
  }

  void _initThemeModeFromStorage() {
    final String? key = _preferences?.getString(AppConst.keyThemeMode);
    _appThemeType = getAppThemType(key);
    updateTheme();
  }

  void updateTheme() {
    late AppThemeResult appThemeCompanyResult;
    final BaseFont nextBaseFont = BaseFont();

    switch (DevicePlatformManager().typePlatform) {
      case TypePlatform.mobile:
        appThemeCompanyResult = _appThemeType.appThemeMobile(
          appFont: nextBaseFont,
        );

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarBrightness: appThemeCompanyResult.statusBarBrightness,
            statusBarColor: appThemeCompanyResult.appColor.statusBarColor,
            statusBarIconBrightness:
                appThemeCompanyResult.statusBarIconBrightness,
          ),
        );
        break;
    }

    color = appThemeCompanyResult.appColor;
    textStyle = appThemeCompanyResult.appTextStyle;
    theme = appThemeCompanyResult.appTheme;
    baseFont = appThemeCompanyResult.appFont;
  }

  AppThemeType getAppThemType(String? key) {
    if (key == AppThemeType.light.toString()) {
      return AppThemeType.light;
    }
    return AppThemeType.dark;
  }
}
