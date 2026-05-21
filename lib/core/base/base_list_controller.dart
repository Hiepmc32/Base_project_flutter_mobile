import 'package:fresh_base_project/core/errors/failure.dart';
import 'package:fresh_base_project/core/types/result.dart';

import 'base_cubit.dart';
import 'base_list_state.dart';
import 'base_state.dart';

/// Base cubit for screens that load a list and expose loading/error state.
abstract class BaseListController<T> extends BaseCubit<BaseListState<T>> {
  BaseListController([BaseListState<T>? initialState])
    : super(initialState ?? BaseListState<T>());

  ResultFuture<List<T>> loadItems();

  Future<void> fetchItems() async {
    showLoading();
    emit(state.copyWith(status: BaseStatus.loading, clearErrorMessage: true));

    final result = await loadItems();
    result.fold(_handleFailure, _handleSuccess);

    hideLoading();
  }

  Future<void> refreshItems() => fetchItems();

  void _handleFailure(Failure failure) {
    emit(
      state.copyWith(
        status: BaseStatus.failure,
        items: List<T>.empty(growable: false),
        errorMessage: failure.message,
      ),
    );
  }

  void _handleSuccess(List<T> items) {
    emit(
      state.copyWith(
        status: BaseStatus.success,
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
