import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/app_theme_manager.dart';

class AppThemeDark extends AppTheme {
  @override
  ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: primary,
    useMaterial3: true,
    primaryColor: primary,
    fontFamily: AppThemeManger().baseFont.fontRegular,
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  @override
  Color get primary => Colors.black;
}
