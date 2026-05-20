import 'dart:async';

import 'package:fresh_base_project/core/utils/device/device_platform.dart';

import 'base_controller.dart';

abstract class BaseMainController<T> with BaseController {
  BaseMainController({
    this.currentPageDesktop,
    required this.currentPage,
    this.pageChanges,
    this.currentPageProvider,
  });

  final T currentPage;
  final T? currentPageDesktop;
  final Stream<T>? pageChanges;
  final T Function()? currentPageProvider;

  StreamSubscription<T>? _subscription;

  T? get currentPageValue =>
      DevicePlatformManager().typePlatform == TypePlatform.mobile
          ? currentPage
          : currentPageDesktop;

  void onInit() {
    if (pageChanges != null) {
      _subscription = pageChanges!.listen((T pageChange) {
        if (pageChange == currentPageValue) {
          initPage();
        }
      });

      final T? selected = currentPageProvider?.call();
      if (selected != null && selected == currentPageValue) {
        initPage(onInit: true);
      }
    }
  }

  void initPage({bool onInit = false}) {}

  bool get isCurrentPage {
    final T? selected = currentPageProvider?.call();
    return selected != null && currentPageValue == selected;
  }

  void dispose() {
    onDisposeController();
    _subscription?.cancel();
  }
}
