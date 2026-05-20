import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoadingController extends Cubit<bool> {
  LoadingController() : super(false);

  int _count = 0;

  void show() {
    _count += 1;
    if (_count == 1) {
      emit(true);
    }
  }

  void hide() {
    if (_count > 0) {
      _count -= 1;
    }

    if (_count == 0) {
      emit(false);
    }
  }

  void hideAll() {
    _count = 0;
    emit(false);
  }
}
