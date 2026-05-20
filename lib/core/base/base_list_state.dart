import 'package:equatable/equatable.dart';

/// Common UI status for screens that load list data.
enum BaseListStatus { initial, loading, success, failure }

/// Generic immutable state for list-based screens.
class BaseListState<T> extends Equatable {
  const BaseListState({
    this.status = BaseListStatus.initial,
    this.items = const <T>[],
    this.errorMessage,
  });

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
