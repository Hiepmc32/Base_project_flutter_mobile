import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_const.dart';

@lazySingleton
class AppLocaleController extends Cubit<Locale> {
  AppLocaleController({required SharedPreferences preferences})
    : _preferences = preferences,
      super(_readLocale(preferences));

  final SharedPreferences _preferences;

  static Locale _readLocale(SharedPreferences preferences) {
    final String? languageCode = preferences.getString(AppConst.keyLocale);
    switch (languageCode) {
      case 'en':
        return const Locale('en');
      case 'vi':
      default:
        return const Locale('vi');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) {
      return;
    }
    emit(locale);
    await _preferences.setString(AppConst.keyLocale, locale.languageCode);
  }
}
