import 'dart:io';

import 'package:fresh_base_project/core/utils/formatters/remove_accent_converter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoDetail {
  DeviceInfoDetail({
    this.name,
    this.model,
    this.systemVersion,
    this.ipAddress,
    this.os,
    this.version,
    this.versionSDKAndroid,
  });

  factory DeviceInfoDetail.fromJson(Map<String, dynamic> json) =>
      DeviceInfoDetail(
        name: json['name'] as String,
        model: json['model'] as String,
        systemVersion: json['systemVersion'] as String,
        ipAddress: json['ipAddress'] as String,
        version: json['version'] as String,
      );

  final String? name;
  final String? model;
  final String? systemVersion;
  final String? ipAddress;
  final int? os;
  final String? version;
  final num? versionSDKAndroid;

  //{deviceId: 7d7e799959a7962d, name: samsung, model: SM-A505F, systemVersion: 30, ipAddress: 172.16.0.81, token: null, permission: null},

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name?.replaceAll(RegExp(r'[^\w\s]+'), ''),
    'model': model,
    'systemVersion': systemVersion,
    'ipAddress': ipAddress,
    'os': '$os',
    'version': version,
  };

  Map<String, dynamic> toMapLog() => <String, dynamic>{
    'name': name?.replaceAll(RegExp(r'[^\w\s]+'), ''),
    'model': model,
    'systemVersion': systemVersion,
    'ipAddress': ipAddress,
  };
}

class DeviceInfo {
  DeviceInfo({this.deviceId, this.deviceInfo, this.macAddress});

  final String? deviceId;
  final DeviceInfoDetail? deviceInfo;
  final String? macAddress;
  String? token; // token firebase realtime
  bool? permission; // notification Permission realtime

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'deviceId': deviceId,
      'token': token,
      'permission': permission,
    };
    if (deviceInfo != null) {
      map.addAll(deviceInfo!.toMapLog());
    }

    return map;
  }
}

Future<DeviceInfo> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  DeviceInfo? deviceData;
  DeviceInfoDetail deviceInfoDetail;
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String? platformVersion;

  try {
    platformVersion = 'Unknown mac address';
  } on PlatformException {
    platformVersion = 'Failed to get mac address.';
  } catch (e) {
    // Handle error silently
  }
  // versionRx.value = '${_packageInfo.version}.${_packageInfo.buildNumber}';

  try {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo deviceDataAndroid =
          await deviceInfoPlugin.androidInfo;

      deviceInfoDetail = DeviceInfoDetail(
        model: ConvertHelper.removeAccents(deviceDataAndroid.model),
        name: ConvertHelper.removeAccents(deviceDataAndroid.manufacturer),
        systemVersion: ConvertHelper.removeAccents(await getDeviceOS()),
        ipAddress: await getIps(),
        os: 2,
        versionSDKAndroid: deviceDataAndroid.version.sdkInt,
        version: packageInfo.version,
      );
      String? androidId;
      // try {
      //   MethodChannel platform = MethodChannel('com.flutter.ekyc_vnpt_goline');

      //   final dynamic result = await platform.invokeMethod(
      //     'getId',
      //     <String, dynamic>{},
      //   );
      //   if (result is String?) {
      //     androidId = result;
      //   }
      // } catch (e) {
      //   // Handle error silently
      // }

      deviceData = DeviceInfo(
        deviceId: androidId ?? deviceDataAndroid.id,
        deviceInfo: deviceInfoDetail,
        macAddress: platformVersion,
      );
    } else if (Platform.isIOS) {
      final IosDeviceInfo deviceDataIOS = await deviceInfoPlugin.iosInfo;

      deviceInfoDetail = DeviceInfoDetail(
        model: ConvertHelper.removeAccents(deviceDataIOS.model),
        name: ConvertHelper.removeAccents(deviceDataIOS.name),
        systemVersion: ConvertHelper.removeAccents(await getDeviceOS()),
        ipAddress: await getIps(),
        os: 1,
        version: packageInfo.version,
      );

      deviceData = DeviceInfo(
        deviceId: deviceDataIOS.identifierForVendor,
        deviceInfo: deviceInfoDetail,
        macAddress: platformVersion,
      );
    } else if (Platform.isMacOS) {
      final MacOsDeviceInfo macOsDeviceInfo = await deviceInfoPlugin.macOsInfo;
      deviceInfoDetail = DeviceInfoDetail(
        model: ConvertHelper.removeAccents(macOsDeviceInfo.model),
        name: ConvertHelper.removeAccents(macOsDeviceInfo.computerName),
        systemVersion: ConvertHelper.removeAccents(await getDeviceOS()),
        ipAddress: await getIps(),
        os: 3,
        version: packageInfo.version,
      );

      deviceData = DeviceInfo(
        deviceId: macOsDeviceInfo.systemGUID,
        deviceInfo: deviceInfoDetail,
        macAddress: platformVersion,
      );
      // final MacOS
    } else if (Platform.isWindows) {
      final WindowsDeviceInfo macOsDeviceInfo =
          await deviceInfoPlugin.windowsInfo;
      deviceInfoDetail = DeviceInfoDetail(
        model: ConvertHelper.removeAccents(macOsDeviceInfo.computerName),
        name: ConvertHelper.removeAccents(macOsDeviceInfo.computerName),
        systemVersion: ConvertHelper.removeAccents(await getDeviceOS()),
        ipAddress: await getIps(),
        os: 4,
        version: packageInfo.version,
      );

      deviceData = DeviceInfo(
        deviceId: macOsDeviceInfo.deviceId,
        deviceInfo: deviceInfoDetail,
        macAddress: platformVersion,
      );
      // final MacOS
    }
  } on PlatformException {
    deviceData = DeviceInfo();
  }
  // deviceData = DeviceInfo(
  //   deviceId: 'TP1A.220624.014',
  //   deviceInfo: DeviceInfoDetail(
  //     name: 'samsung',
  //     ipAddress: '30.47.190.156',
  //     model: 'SM-M336B',
  //     os: 2,
  //     systemVersion: 'Android 13 (SDK 33), samsung SM-M336B',
  //     version: '1.0.0-uat.98',
  //   ),
  // );

  return deviceData ?? DeviceInfo();
}

Future<String> getDeviceOS() async {
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    final String release = androidInfo.version.release;
    final int sdkInt = androidInfo.version.sdkInt;
    final String manufacturer = androidInfo.manufacturer;
    final String model = androidInfo.model;
    return 'Android $release (SDK $sdkInt), $manufacturer $model';
    // Android 9 (SDK 28), Xiaomi Redmi Note 7
  }

  if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
    final String systemName = iosInfo.systemName;
    final String version = iosInfo.systemVersion;
    final String name = iosInfo.name;
    final String model = iosInfo.model;
    return '$systemName $version, $name $model';
    // iOS 13.1, iPhone 11 Pro Max iPhone
  }

  if (Platform.isMacOS) {
    final MacOsDeviceInfo macOsDeviceInfo = await DeviceInfoPlugin().macOsInfo;
    final String osRelease = macOsDeviceInfo.osRelease;
    final String model = macOsDeviceInfo.model;
    return 'macos $osRelease $model';
  }
  if (Platform.isWindows) {
    final WindowsDeviceInfo macOsDeviceInfo =
        await DeviceInfoPlugin().windowsInfo;
    final String osRelease = macOsDeviceInfo.csdVersion;
    final String model = macOsDeviceInfo.computerName;
    return 'windows $osRelease $model';
  }

  return 'Undefine';
}

Future<String> getIps() async {
  String ip = '';
  for (final NetworkInterface interface in await NetworkInterface.list()) {
    for (final InternetAddress addr in interface.addresses) {
      // print(
      //     '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');

      if (addr.type == InternetAddressType.IPv4) {
        ip = addr.address;
      } else if (ip.isEmpty && addr.type == InternetAddressType.IPv6) {
        ip = addr.address;
      }
    }
  }

  return ip;
}
