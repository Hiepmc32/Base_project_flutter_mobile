// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Du an mau';

  @override
  String get usersTitle => 'Nguoi dung';

  @override
  String noUsers(Object users) {
    return 'Khong co du lieu nguoi dung $users';
  }
}
