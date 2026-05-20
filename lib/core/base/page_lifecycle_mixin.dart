import 'package:flutter/widgets.dart';

mixin PageLifecycleMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  void onInit() {}

  void onReady() {}

  void onResumed() {}

  void onInactive() {}

  void onHidden() {}

  void onPaused() {}

  void onDetached() {}

  void onDispose() {}

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onReady();
      }
    });
  }

  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    onDispose();
    super.dispose();
  }
}
