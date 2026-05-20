import 'dart:math';

import 'package:intl/intl.dart';
import 'extension.dart';

extension CurrencyFormat on num {
  String formatPrice({
    int decimalDigits = 2,
    bool convertToThounsand = false,
    bool removeFormatThounsand = false,
    bool trimBilion = false,
    bool getAbs = false,

    /// If set to true, function will remove the .00 at the last of value
    /// Eg 69.00 -> 69
    bool trimZero = false,
    bool zeroToEmpty = false,
    String endPoint = '',
  }) {
    num value = this;
    if (convertToThounsand) {
      value = value / 1000;
    }

    if (trimBilion) {
      value = value / 1000000000;
    }

    // if (this > 1000 && decimalDigits != 0) {
    //   decimalDigits = 1;
    // }

    if (trimZero) {
      if (value == value.round().toDouble()) {
        // ignore: parameter_assignments
        decimalDigits = 0;
      } else {
        String numberString = value.toString();

        if (numberString.contains('.')) {
          List<String> parts = numberString.split('.');

          // Phần thập phân là phần sau dấu chấm
          String decimalPart = parts[1];
          if (decimalDigits > decimalPart.length) {
            decimalDigits = decimalPart.length;
          }
        }
      }
    }

    if (zeroToEmpty && value == 0) {
      return '';
    }

    final NumberFormat format = NumberFormat.currency(
      locale: 'en-US',
      symbol: '',
      decimalDigits: decimalDigits,
    );
    String abs = '';

    if (value > 0 && getAbs) {
      abs = '+';
    }

    if (removeFormatThounsand) {
      return abs + (format.format(value) + endPoint).replaceSemicolon();
    } else {
      return abs + format.format(value) + endPoint;
    }
  }

  /// xoá số 0 sau phần thập phân 12.50 ==>12.5
  String formatVolumnDecimal({int decimalDigits = 2, bool getAbs = false}) {
    String value = formatVolume(decimalDigits: decimalDigits, getAbs: getAbs);
    RegExp regex = RegExp(r'0*$'); // xáo số `0` sau phần thập phân
    RegExp regex1 = RegExp(r'\.$'); // xáo dấu chấm '.' nếu phần thập phân trống

    return value.replaceAll(regex, '').replaceAll(regex1, '');
  }

  String formatVolume({
    int decimalDigits = 0,
    bool convertToThounsand = false,
    bool trimBilion = false,
    bool getAbs = false,

    /// If set to true, function will remove the .00 at the last of value
    /// Eg 69.00 -> 69
    bool trimZero = false,
    bool zeroToEmpty = false,
    bool convertAbcs = false,
  }) {
    num value = this;
    if (getAbs) {
      value = abs();
    }
    if (convertToThounsand) {
      value = value / 1000;
    }

    if (trimBilion) {
      value = value / 1000000000;
    }

    if (trimZero) {
      if (value == value.round().toDouble()) {
        // ignore: parameter_assignments
        decimalDigits = 0;
      }
    }

    if (zeroToEmpty && value == 0) {
      return '';
    }

    final NumberFormat format = NumberFormat.currency(
      locale: 'en-US',
      symbol: '',
      decimalDigits: decimalDigits,
    );
    return format.format(value);
  }

  String formatBillion({
    int decimalDigits = 2,
    bool getAbs = false,
    bool trimZero = false,
    String currency = '',
    num divide = 1000000000,
  }) {
    num value = this;
    if (getAbs) {
      value = abs();
    }

    value = value / divide;

    String roundedValue = value.toStringAsFixed(decimalDigits);

    if (decimalDigits == 0) {
      if (double.parse(roundedValue) ==
          double.parse(roundedValue).roundToDouble()) {
        roundedValue = value.toStringAsFixed(0);
      }
    }
    final NumberFormat format = NumberFormat.currency(
      locale: 'en-US',
      symbol: '',
      decimalDigits: decimalDigits,
    );
    return '${format.format(value)} $currency';
  }

  String formatRate(int decimalDigits, {bool getAbs = false}) {
    int decDigitsToFormat = decimalDigits;

    final double roundVal = roundToDouble();
    if (roundVal == this) {
      decDigitsToFormat = 0;
    }

    final NumberFormat format = NumberFormat.currency(
      locale: 'en-US',
      symbol: '',
      decimalDigits: decDigitsToFormat,
    );
    final String result = format.format(this);

    String abs = '';

    if (this > 0 && getAbs) {
      abs = '+';
    }

    return abs + result;
  }

  String formatHHMM() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);
    final DateFormat dateFormat = DateFormat.Hm();
    return dateFormat.format(date);
  }

  String formatDMMYYYYHHMMSS() {
    if (this <= 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);

    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  String formatDMMYYYYHH() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);

    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String formatTimeStampDMMYYYY() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);

    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatTimeStampDMM() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);

    return DateFormat('dd/MM').format(date);
  }

  String formatTimeStampyyyMMdd() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);
    return DateFormat('yyyyMMdd').format(date);
  }

  String formatTimeStampyyyyMMddHHss() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  String formatDMMYYY() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);

    return DateFormat('dd/MM/yy').format(date);
  }

  String formatDateDDMM() {
    if (this <= 0) {
      return '';
    }

    final DateTime date = DateTime.parse('$this');

    return DateFormat('dd/MM').format(date);
  }

  String formatDMMYYYY() {
    if (this == 0) return '';
    try {
      final DateTime date = DateTime.parse('$this');

      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return "";
    }
  }

  bool isBetween(num? from, num? to) {
    return (from ?? 0) <= this && this <= (to ?? 0);
  }

  String get lessBeThanTen => this < 10 ? '0$this' : '$this';

  String formatToHHMM() {
    return DateFormat(
      'HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(toInt()));
  }

  String formatToHHMMSS() {
    return DateFormat(
      'HH:mm:ss',
    ).format(DateTime.fromMillisecondsSinceEpoch(toInt()));
  }

  String formatToDDMMyy() {
    return DateFormat(
      'dd/MM/yy',
    ).format(DateTime.fromMillisecondsSinceEpoch(toInt()));
  }

  String formatToDDMMYYYY() {
    return DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.fromMillisecondsSinceEpoch(toInt()));
  }

  String get getPrefix => this > 0 ? '+' : '';

  String getTimeDisp() {
    String matTimeSt = toStringAsFixed(0);

    if (matTimeSt.length != 5 && matTimeSt.length != 6) {
      return matTimeSt;
    }

    if (matTimeSt.length == 5) {
      matTimeSt = '0$matTimeSt';
    }

    // ignore: lines_longer_than_80_chars
    return '${matTimeSt.substring(0, 2)}:${matTimeSt.substring(2, 4)}:${matTimeSt.substring(4, 6)}';
  }

  num toPrecision(int n) {
    return num.parse(toStringAsFixed(n));
  }

  num truncateToDecimalPlaces(int? fractionalDigits) {
    if (fractionalDigits != null) {
      return (this * pow(10, fractionalDigits)).truncate() /
          pow(10, fractionalDigits);
    }
    return this;
  }

  num truncateToDecimalPlacesRound(int fractionalDigits) {
    String? value = toString().split('.').tryGet(1);

    if (value != null && value.length <= fractionalDigits) {
      return this;
    }

    final num a =
        (this * pow(10, fractionalDigits)).truncate() /
        pow(10, fractionalDigits);
    if (a == round()) {
      return round().toInt();
    } else {
      return a;
    }
  }

  /// làm tròn lên hoặc xuống Phần thập phân
  num roundTo(int fractionalDigits) {
    final num mod = pow(10, fractionalDigits);
    return ((this * mod).round().toDouble() / mod);
  }

  String formatHHMMSS() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);
    final DateFormat dateFormat = DateFormat.Hms();
    return dateFormat.format(date);
  }

  String formatDateDDMMYYYY() {
    // final num s = this;
    // return '${s.toString().substring(0, 4)}/${s.toString().substring(4, 6)}/${s.toString().substring(6)}';

    if (this <= 0) {
      return '';
    }

    final DateTime date = DateTime.parse('$this');

    return DateFormat('dd/MM/yyyy').format(date);
  }

  //20230101 -> dateTime
  DateTime numToDateTime({DateTime? dateTimeDefault}) {
    try {
      return DateTime.parse('$this');
    } catch (e) {
      return dateTimeDefault ?? DateTime.now();
    }
  }

  String formatCurrency({
    int decimalDigits = 2,
    required String thousand,
    required String million,
    required String billion,
  }) {
    if (abs() >= 1000000000) {
      return ((this / 1000000000).toStringAsFixed(decimalDigits) + billion);
    }
    if (abs() >= 1000000) {
      return ((this / 1000000).toStringAsFixed(decimalDigits) + million);
    }
    if (abs() >= 1000) {
      return ((this / 1000).toStringAsFixed(decimalDigits) + thousand);
    }

    return formatVolume();
  }

  DateTime formatDateYYYYMMDD() {
    if (this == 0) {
      return DateTime.now();
    }
    String input = '$this';
    String newInput =
        '${input.substring(0, 4)}/${input.substring(4, 6)}/${input.substring(6, 8)}';
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.parse(newInput);
  }

  DateTime convertToDate({DateTime? defaultDate}) {
    try {
      return DateFormat('yyyyMMdd').parse(toString());
    } catch (e) {
      return defaultDate ?? DateTime.now();
    }
  }

  String formatDMMYYHHMMSS() {
    if (this == 0) {
      return '';
    }
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(toInt() * 1000);

    return DateFormat('dd/MM/yy HH:mm:ss').format(date);
  }

  int countDecimalPlaces() {
    String? decimalPart = toString().split('.').tryGet(1);
    return decimalPart?.length ?? 2;
  }
}

extension DoubleEx on double {
  double roundDouble({int places = 2}) {
    final num mod = pow(10.0, places);
    return (this * mod).round().toDouble() / mod;
  }
}

extension IntegerEx on int {
  String formatToDDMMYYYY() {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(toInt());
    final DateFormat formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }

  String formatToHHMM() {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(toInt());
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}
