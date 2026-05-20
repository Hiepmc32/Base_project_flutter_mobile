import 'package:fresh_base_project/core/utils/device/device_platform.dart';
import 'package:fresh_base_project/core/utils/ui/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme/app_theme_dark.dart';
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

  AppTheme theme = AppThemeDark();
  AppTextStyle textStyle = AppTextStyle();
  BaseFont baseFont = BaseFont();

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

    switch (DevicePlatformManager().typePlatform) {
      case TypePlatform.mobile:
        appThemeCompanyResult = _appThemeType.appThemeMobile();

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarBrightness: appThemeCompanyResult.statusBarBrightness,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                appThemeCompanyResult.statusBarIconBrightness,
          ),
        );
        break;
    }

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
