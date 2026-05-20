import 'package:fresh_base_project/core/base/loading_controller.dart';
import 'package:fresh_base_project/locator.dart';

mixin BaseController {
  LoadingController get loading => getIt<LoadingController>();

  void showLoading() {
    loading.show();
  }

  void hideLoading() {
    loading.hide();
  }

  void onDisposeController() {
    loading.hideAll();
  }
}
