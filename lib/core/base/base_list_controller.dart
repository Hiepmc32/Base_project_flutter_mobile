import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_project/core/errors/failure.dart';
import 'package:fresh_base_project/core/types/result.dart';

import 'base_controller.dart';
import 'base_list_state.dart';

/// Base cubit for screens that load a list and expose loading/error state.
abstract class BaseListController<T> extends Cubit<BaseListState<T>>
    with BaseController {
  BaseListController([BaseListState<T>? initialState])
    : super(initialState ?? BaseListState<T>());

  ResultFuture<List<T>> loadItems();

  Future<void> fetchItems() async {
    showLoading();
    emit(
      state.copyWith(status: BaseListStatus.loading, clearErrorMessage: true),
    );

    final result = await loadItems();
    result.fold(_handleFailure, _handleSuccess);

    hideLoading();
  }

  Future<void> refreshItems() => fetchItems();

  void _handleFailure(Failure failure) {
    emit(
      state.copyWith(
        status: BaseListStatus.failure,
        items: List<T>.empty(growable: false),
        errorMessage: failure.message,
      ),
    );
  }

  void _handleSuccess(List<T> items) {
    emit(
      state.copyWith(
        status: BaseListStatus.success,
        items: items,
        clearErrorMessage: true,
      ),
    );
  }

  @override
  Future<void> close() {
    onDisposeController();
    return super.close();
  }
}
