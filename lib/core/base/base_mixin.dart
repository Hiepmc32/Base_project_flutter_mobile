import 'package:fresh_base_project/locator.dart';

import '../themes/themes.dart';

export 'package:flutter/material.dart';

mixin BaseMixin {
  AppTheme get color => getIt<AppThemeManger>().theme;

  AppTextStyle get textStyle => getIt<AppThemeManger>().textStyle;
}
