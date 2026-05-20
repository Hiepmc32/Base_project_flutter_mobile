import 'dart:io';

import 'package:flutter/widgets.dart';

class DevicePlatformManager {
  late TypePlatform typePlatform;
  late DevicePlatform devicePlatform;
  late bool isMobile;
  factory DevicePlatformManager() {
    return _singleton;
  }

  DevicePlatformManager._internal() {
    typePlatform = checkTypePlatform();
    devicePlatform = getDevicePlatform();
    isMobile = typePlatform == TypePlatform.mobile;
  }

  static final DevicePlatformManager _singleton =
      DevicePlatformManager._internal();

  TypePlatform checkTypePlatform() {
    final MediaQueryData data = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    if (data.size.shortestSide < 550) {
      return TypePlatform.mobile;
    }
    return TypePlatform.mobile;
  }

  DevicePlatform getDevicePlatform() {
    if (Platform.isIOS) {
      return DevicePlatform.ios;
    } else if (Platform.isAndroid) {
      return DevicePlatform.android;
    } else if (Platform.isWindows) {
      return DevicePlatform.window;
    } else if (Platform.isMacOS) {
      return DevicePlatform.macos;
    } else {
      return DevicePlatform.linux;
    }
  }
}

enum TypePlatform { mobile }

enum DevicePlatform {
  ios,
  android,
  window,
  macos,
  linux;

  String get value {
    switch (this) {
      case DevicePlatform.ios:
        return '1';
      case DevicePlatform.android:
        return '2';
      case DevicePlatform.window:
        return '3';

      case DevicePlatform.macos:
        return '4';

      case DevicePlatform.linux:
        return '5';
    }
  }
}
