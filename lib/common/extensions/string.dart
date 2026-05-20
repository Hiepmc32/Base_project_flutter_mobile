import 'package:intl/intl.dart';

extension StringEx on String {
  bool get isNumber {
    return num.tryParse(replaceAll(',', '')) is num;
  }

  bool get isString => RegExp('[a-zA-Z]').hasMatch(this);

  bool get validCharSpec => RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);

  String removeString() {
    return replaceAll(RegExp(r'[^0-9,.]'), '');
  }

  String formatDecimal(String s) {
    return s.replaceAll('', '');
  }

  String formatToDDMMYYYY() {
    try {
      final DateTime dateTime = DateTime.parse(this);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String formatToDDMM() {
    try {
      final DateTime dateTime = DateTime.parse(this);
      final DateFormat formatter = DateFormat('dd/MM');
      return formatter.format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String formatToDDMMYYYYs() {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      int.tryParse(this) ?? 0,
    );
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  String replaceSemicolon({String fromDecimal = ',', String toDecimal = ''}) {
    return replaceAll(fromDecimal, toDecimal);
  }

  DateTime convertStringToDate() {
    return DateFormat('dd/MM/yyyy').parse(this);
  }

  // 4/26/2022 12:00:00 AM
  DateTime convertToDateType2() {
    return DateFormat('MM/dd/yyyy HH:mm:ss aaa').parse(this);
  }

  // "reqTime" -> "16/07/2024 16:55:47"
  DateTime? convertToDateType3() {
    try {
      return DateFormat('dd/MM/yyyy HH:mm:ss').parse(this);
    } catch (e) {
      return null;
    }
  }

  num formatNumber() {
    return num.tryParse(replaceSemicolon()) ?? 0;
  }

  String formatNumberToString() {
    return (num.tryParse(replaceSemicolon()) ?? 0).toString();
  }

  String? getTimeH() {
    try {
      final DateTime result = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(this);
      final DateFormat output = DateFormat('HH:mm');
      return output.format(result);
    } catch (_) {
      return '';
    }
  }

  String getTimeD() {
    try {
      final DateTime result = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(this);
      final DateFormat output = DateFormat('dd/MM');
      return output.format(result);
    } catch (_) {
      return '';
    }
  }

  String getTimeDDMMYYYY() {
    try {
      final DateTime result = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(this);
      final DateFormat output = DateFormat('dd/MM/yyyy');
      return output.format(result);
    } catch (_) {
      return '';
    }
  }

  String formatToDDMMYYYYHHMM() {
    try {
      final DateTime dateTime = DateTime.parse(this);
      final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
      return formatter.format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String formatToDDMMYYYYHHMMss() {
    try {
      final DateTime dateTime = DateTime.parse(this).add(Duration(hours: 7));
      final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm:ss');
      return formatter.format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String formatYYYYMMDD() {
    final DateTime dateTime = DateTime.parse(this);
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(dateTime);
  }

  String? formatYYYYMMDDServer() {
    try {
      // Define the input and output formats
      DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      DateFormat outputFormat = DateFormat('yyyyMMdd');

      // Parse the input date string to a DateTime object
      DateTime dateTime = inputFormat.parse(this);

      // Format the DateTime object to the desired output format
      String formattedDate = outputFormat.format(dateTime);

      return formattedDate;
    } catch (e) {
      return null;
    }
  }

  double get parseNumeric => double.parse(this);

  String convertDateTimeFormat() {
    try {
      DateTime parsedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(this);
      String formattedDateTime = DateFormat(
        "dd/MM/yyyy HH:mm:ss",
      ).format(parsedDateTime);
      return formattedDateTime;
    } catch (_) {
      return '';
    }
  }

  String convertNormalChar() {
    String str = this;
    str = str.replaceAll(RegExp(r'/á|à|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g'), 'a');
    str = str.replaceAll(RegExp(r'/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g'), 'e');
    str = str.replaceAll(RegExp(r'/ì|í|ị|ỉ|ĩ/g'), 'i');
    str = str.replaceAll(RegExp(r'/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g'), 'o');
    str = str.replaceAll(RegExp(r'/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g'), 'u');
    str = str.replaceAll(RegExp(r'/ỳ|ý|ỵ|ỷ|ỹ/g'), 'y');
    str = str.replaceAll(RegExp(r'/đ/g'), 'd');
    str = str.replaceAll(RegExp(r'/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g'), 'A');
    str = str.replaceAll(RegExp(r'/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g'), 'E');
    str = str.replaceAll(RegExp(r'/Ì|Í|Ị|Ỉ|Ĩ/g'), 'I');
    str = str.replaceAll(RegExp(r'/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g'), 'O');
    str = str.replaceAll(RegExp(r'/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g'), 'U');
    str = str.replaceAll(RegExp(r'/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g'), 'Y');
    str = str.replaceAll(RegExp(r'/Đ/g'), 'D');
    // Some system encode vietnamese combining accent as individual utf-8 characters
    // Một vài bộ encode coi các dấu mũ, dấu chữ như một kí tự riêng biệt nên thêm hai dòng này
    str = str.replaceAll(
      RegExp(r'/\u0300|\u0301|\u0303|\u0309|\u0323/g'),
      '',
    ); // ̀ ́ ̃ ̉ ̣  huyền, sắc, ngã, hỏi, nặng
    str = str.replaceAll(
      RegExp(r'/\u02C6|\u0306|\u031B/g'),
      '',
    ); // ˆ ̆ ̛  Â, Ê, Ă, Ơ, Ư
    // Remove extra spaces
    // Bỏ các khoảng trắng liền nhau
    str = str.replaceAll(RegExp(r'/ + /g'), ' ');
    str = str.trim();
    return str;
  }

  double formatNumberDouble() {
    return double.tryParse(replaceSemicolon()) ?? 0;
  }

  DateTime convertStringToDateAfer({int year = 15}) {
    try {
      final DateTime date = DateFormat('dd/MM/yyyy').parse(this);
      final int d = date.day;
      final int m = date.month;
      final int y = date.year + year;
      return DateFormat('dd/MM/yyyy').parse('$d/$m/$y');
    } catch (e) {
      return DateTime.fromMicrosecondsSinceEpoch(0);
    }
  }

  bool validateEmail() {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this);
  }

  bool validateMobile() {
    return RegExp(r'(0[3|5|7|8|9])+([0-9]{8})\b').hasMatch(this);
  }
}

extension StringExNull on String? {
  bool get isStringNotEmpty => this != null && this!.trim().isNotEmpty;

  bool get isStringEmpty => this != null && this!.trim().isEmpty;

  bool get isString => RegExp('[a-zA-Z]').hasMatch(this!);

  bool get isNumeric {
    if (this == null) {
      return false;
    }
    return double.tryParse(this!) != null;
  }

  String get convertScreenLog {
    if (this == null) {
      return '';
    }

    final List<String> routers = this?.split('/') ?? [];
    if (routers.length > 1) {
      return routers.last;
    }
    return this!;
  }
}
