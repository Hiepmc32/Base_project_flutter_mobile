import '../../app/di/locator.dart';
import '../../app/themes/themes.dart';

export 'package:flutter/material.dart';

mixin BaseMixin {
  AppTheme get color => getIt<AppThemeManger>().theme;

  AppTextStyle get textStyle => getIt<AppThemeManger>().textStyle;
}
