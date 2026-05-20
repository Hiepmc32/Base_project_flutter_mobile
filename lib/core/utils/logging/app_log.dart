import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class AppLog {
  // Factory constructor that returns the singleton instance
  factory AppLog() {
    return _instance;
  }
  // Private named constructor
  AppLog._internal() {
    loger = Logger('MOBILE-APP');

    Logger.root.level = Level.ALL; // defaults to Level.INFO
  }
  static final AppLog _instance = AppLog._internal();

  Future<void> init() async {
    Logger.root.onRecord.listen((LogRecord record) {
      final String message =
          '${record.time}: ${record.loggerName}: ${record.level.name}: ${record.message}';
      debugPrint(
        '------------------------------->START<-------------------------------',
      );
      debugPrint(message);
      debugPrint(
        '------------------------------->END<--------------------------------',
      );
    });
  }

  // Logger instance
  late final Logger loger;

  static final AppLog log = AppLog();

  // final String? className;

  void info(dynamic message) {
    if (!kReleaseMode) {
      // debugPrint(message);

      loger.info(message);
    }
  }

  void infoWithDebug(dynamic message) {
    if (!kReleaseMode) {
      // debugPrint(message);

      loger.info(message);
    }
  }

  void warning(dynamic message) {
    if (!kReleaseMode) {
      loger.warning(message);
    }
  }

  void config(dynamic message) {
    if (!kReleaseMode) {
      loger.config(message);
    }
  }

  /// Emit a [info] log event
  void printInfo(dynamic info) {
    if (!kReleaseMode) {
      // ignore: avoid_print
      print('\u001b[32m[INFO]: $info\u001b[0m');
    }
  }

  /// Emit a [warning] log event
  void printWarning(dynamic warning) {
    if (!kReleaseMode) {
      // ignore: avoid_print
      print('\u001B[34m[WARNING]: $warning\u001b[0m');
    }
  }

  /// Emit a [error] log event
  void printError(dynamic error) {
    if (!kReleaseMode) {
      // ignore: avoid_print
    }
  }

  /// Emit a [error] log event
  void debugPrint(dynamic mms) {
    if (kDebugMode) {
      // ignore: avoid_print
      print(mms);
    }
  }
}
