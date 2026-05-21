import 'package:flutter/material.dart';

abstract class AppColor {
  Color get primary;

  Color get onPrimary;

  Color get secondary;

  Color get onSecondary;

  Color get background;

  Color get surface;

  Color get onSurface;

  Color get card;

  Color get divider;

  Color get textPrimary;

  Color get textSecondary;

  Color get textDisabled;

  Color get icon;

  Color get disabled;

  Color get error;

  Color get success;

  Color get warning;

  Color get info;

  Color get appBarBackground;

  Color get appBarForeground;

  Color get onError;

  Color get statusBarColor;
}

class AppColorLight extends AppColor {
  static const Color _primary = Color(0xFF2563EB);
  static const Color _onPrimary = Colors.white;
  static const Color _secondary = Color(0xFF14B8A6);
  static const Color _onSecondary = Colors.white;
  static const Color _background = Color(0xFFF8FAFC);
  static const Color _surface = Colors.white;
  static const Color _onSurface = Color(0xFF0F172A);
  static const Color _card = Colors.white;
  static const Color _divider = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF475569);
  static const Color _textDisabled = Color(0xFF94A3B8);
  static const Color _icon = Color(0xFF64748B);
  static const Color _disabled = Color(0xFFCBD5E1);
  static const Color _error = Color(0xFFDC2626);
  static const Color _onError = Colors.white;
  static const Color _success = Color(0xFF16A34A);
  static const Color _warning = Color(0xFFF59E0B);
  static const Color _info = Color(0xFF0EA5E9);

  @override
  Color get primary => _primary;

  @override
  Color get onPrimary => _onPrimary;

  @override
  Color get secondary => _secondary;

  @override
  Color get onSecondary => _onSecondary;

  @override
  Color get background => _background;

  @override
  Color get surface => _surface;

  @override
  Color get onSurface => _onSurface;

  @override
  Color get card => _card;

  @override
  Color get divider => _divider;

  @override
  Color get textPrimary => _textPrimary;

  @override
  Color get textSecondary => _textSecondary;

  @override
  Color get textDisabled => _textDisabled;

  @override
  Color get icon => _icon;

  @override
  Color get disabled => _disabled;

  @override
  Color get error => _error;

  @override
  Color get onError => _onError;

  @override
  Color get success => _success;

  @override
  Color get warning => _warning;

  @override
  Color get info => _info;

  @override
  Color get appBarBackground => primary;

  @override
  Color get appBarForeground => onPrimary;

  @override
  Color get statusBarColor => Colors.transparent;
}

class AppColorDark extends AppColor {
  static const Color _primary = Color(0xFF60A5FA);
  static const Color _onPrimary = Color(0xFF0F172A);
  static const Color _secondary = Color(0xFF2DD4BF);
  static const Color _onSecondary = Color(0xFF0F172A);
  static const Color _background = Color(0xFF0F172A);
  static const Color _surface = Color(0xFF1E293B);
  static const Color _onSurface = Color(0xFFF8FAFC);
  static const Color _card = Color(0xFF1E293B);
  static const Color _divider = Color(0xFF334155);
  static const Color _textPrimary = Color(0xFFF8FAFC);
  static const Color _textSecondary = Color(0xFFCBD5E1);
  static const Color _textDisabled = Color(0xFF64748B);
  static const Color _icon = Color(0xFFCBD5E1);
  static const Color _disabled = Color(0xFF475569);
  static const Color _error = Color(0xFFF87171);
  static const Color _onError = Colors.white;
  static const Color _success = Color(0xFF4ADE80);
  static const Color _warning = Color(0xFFFBBF24);
  static const Color _info = Color(0xFF38BDF8);

  @override
  Color get primary => _primary;

  @override
  Color get onPrimary => _onPrimary;

  @override
  Color get secondary => _secondary;

  @override
  Color get onSecondary => _onSecondary;

  @override
  Color get background => _background;

  @override
  Color get surface => _surface;

  @override
  Color get onSurface => _onSurface;

  @override
  Color get card => _card;

  @override
  Color get divider => _divider;

  @override
  Color get textPrimary => _textPrimary;

  @override
  Color get textSecondary => _textSecondary;

  @override
  Color get textDisabled => _textDisabled;

  @override
  Color get icon => _icon;

  @override
  Color get disabled => _disabled;

  @override
  Color get error => _error;

  @override
  Color get onError => _onError;

  @override
  Color get success => _success;

  @override
  Color get warning => _warning;

  @override
  Color get info => _info;

  @override
  Color get appBarBackground => surface;

  @override
  Color get appBarForeground => textPrimary;

  @override
  Color get statusBarColor => Colors.transparent;
}
