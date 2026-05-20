import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fresh_base_project/app.dart';
import 'package:fresh_base_project/core/config/config.dart';
import 'package:fresh_base_project/core/utils/logging/app_log.dart';
import 'package:fresh_base_project/locator.dart';

/// Application bootstrap for all flavors.
class BaseRunMain {
  static Future<void> runMainApp({required BaseConfig config}) async {
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        await _loadEnv(config.flavor);
        AppConfig.setEnvironment(valueConfig: config);
        await configureDependencies();

        await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
          DeviceOrientation.portraitUp,
        ]);

        if (config.allowBadCertificates) {
          HttpOverrides.global = InsecureHttpOverrides();
        }

        runApp(const App());
      },
      (Object error, StackTrace stackTrace) {
        AppLog.log.warning('Uncaught app error: $error\n$stackTrace');
      },
    );
  }

  static Future<void> _loadEnv(AppFlavor flavor) async {
    final String fileName = 'env/${flavor.name}.env';

    try {
      await dotenv.load(fileName: fileName);
      AppLog.log.info('Loaded env file: $fileName');
    } catch (_) {
      AppLog.log.warning(
        'Env file not found or invalid: $fileName. Falling back to dart-define values.',
      );
    }
  }
}

/// Enables insecure SSL certs for non-production debugging only.
class InsecureHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
