import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Tracks network transport availability for API guard checks.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  bool _isOnline = true;
  StreamSubscription<dynamic>? _subscription;

  bool get isOnline => _isOnline;

  Future<ConnectivityService> init() async {
    await refreshStatus();
    _subscription = _connectivity.onConnectivityChanged.listen((dynamic event) {
      _isOnline = _hasConnectivity(event);
    });
    return this;
  }

  Future<bool> hasConnection() async {
    await refreshStatus();
    return _isOnline;
  }

  Future<void> refreshStatus() async {
    final dynamic result = await _connectivity.checkConnectivity();
    _isOnline = _hasConnectivity(result);
  }

  bool _hasConnectivity(dynamic result) {
    if (result is List<ConnectivityResult>) {
      return result.any(
        (ConnectivityResult item) => item != ConnectivityResult.none,
      );
    }

    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }

    return false;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
