import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart' show AliceConfiguration;
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:flutter/material.dart';

class AliceUtils {
  static final _singleton = AliceUtils._internal();

  factory AliceUtils() {
    return _singleton;
  }

  AliceUtils._internal() {
    _initAlice();
  }

  Alice? alice;
  AliceDioAdapter aliceDioAdapter = AliceDioAdapter();

  GlobalKey<NavigatorState>? get getNavigatorKey => alice?.getNavigatorKey();

  void _initAlice() {
    alice = Alice(
      configuration: AliceConfiguration(
        showInspectorOnShake: true,
        showNotification: false,
      ),
    );

    alice!.addAdapter(aliceDioAdapter);
  }
}
