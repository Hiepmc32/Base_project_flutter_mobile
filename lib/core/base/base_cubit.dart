import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_controller.dart';
import 'base_state.dart';

abstract class BaseCubit<S extends BaseState> extends Cubit<S>
    with BaseController {
  BaseCubit(super.initialState);

  void emitLoading() {
    emit(state.copyWith(status: BaseStatus.loading) as S);
  }

  void emitSuccess() {
    emit(state.copyWith(status: BaseStatus.success) as S);
  }

  void emitFailure() {
    emit(state.copyWith(status: BaseStatus.failure) as S);
  }

  @override
  Future<void> close() {
    onDisposeController();
    return super.close();
  }
}
