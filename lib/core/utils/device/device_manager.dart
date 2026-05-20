import 'device.dart';

class DeviceManager {
  factory DeviceManager() {
    return _singleton;
  }

  DeviceManager._internal();

  static final DeviceManager _singleton = DeviceManager._internal();

  late DeviceInfo deviceInfo;

  Future<void> init() async {
    deviceInfo = await getDeviceInfo();
  }
}
