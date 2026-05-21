import 'base_state.dart';

/// Generic immutable state for list-based screens.
class BaseListState<T> extends BaseState {
  BaseListState({super.status, List<T>? items, this.errorMessage})
    : items = items ?? List<T>.empty(growable: false);

  final List<T> items;
  final String? errorMessage;

  bool get hasData => items.isNotEmpty;

  @override
  BaseListState<T> copyWith({
    BaseStatus? status,
    List<T>? items,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BaseListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[status, items, errorMessage];
}
