import 'package:equatable/equatable.dart';

/// Common UI status for screens that load list data.
enum BaseListStatus { initial, loading, success, failure }

/// Generic immutable state for list-based screens.
class BaseListState<T> extends Equatable {
  BaseListState({
    this.status = BaseListStatus.initial,
    List<T>? items,
    this.errorMessage,
  }) : items = items ?? List<T>.empty(growable: false);

  final BaseListStatus status;
  final List<T> items;
  final String? errorMessage;

  bool get hasData => items.isNotEmpty;

  BaseListState<T> copyWith({
    BaseListStatus? status,
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
