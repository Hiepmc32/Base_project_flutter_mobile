import 'package:equatable/equatable.dart';

enum BaseStatus { initial, loading, success, failure }

class BaseState extends Equatable {
  const BaseState({this.status = BaseStatus.initial});

  final BaseStatus status;

  BaseState copyWith({BaseStatus? status}) {
    return BaseState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => <Object?>[status];
}
