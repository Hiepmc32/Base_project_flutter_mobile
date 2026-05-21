import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di/locator.dart';
import 'base_list_state.dart';
import 'base_cubit.dart';
import 'base_mixin.dart';
import 'base_state.dart';
import 'page_lifecycle_mixin.dart';

abstract class BasePage<C extends BaseCubit<S>, S extends BaseState>
    extends StatefulWidget
    with BaseMixin {
  const BasePage({super.key});

  C createCubit() => getIt<C>();

  void onInit() {}

  void onReady() {}

  void onResumed() {}

  void onInactive() {}

  void onHidden() {}

  void onPaused() {}

  void onDetached() {}

  void onDispose() {}

  bool listenWhen(S previous, S current) => true;

  void listener(BuildContext context, S state) {}

  String? errorMessage(S state) {
    if (state is BaseListState) {
      return state.errorMessage;
    }

    return null;
  }

  Widget buildLoadingWidget(BuildContext context, S state) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildErrorWidget(BuildContext context, S state) {
    return Center(
      child: Text(
        errorMessage(state) ?? 'Something went wrong',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildPage(BuildContext context, S state);

  @override
  State<BasePage<C, S>> createState() => BasePageState<C, S>();
}

class BasePageState<C extends BaseCubit<S>, S extends BaseState>
    extends State<BasePage<C, S>>
    with WidgetsBindingObserver, PageLifecycleMixin<BasePage<C, S>>, BaseMixin {
  late C cubit;
  bool createdByPage = false;

  @override
  void onInit() {
    // Nếu page trước đã cung cấp Cubit, dùng lại
    final C? maybeCubit = context.read<C?>();
    if (maybeCubit != null) {
      cubit = maybeCubit;
    } else {
      cubit = widget.createCubit();
      createdByPage = true;
    }

    widget.onInit();
  }

  @override
  void onReady() {
    widget.onReady();
  }

  @override
  void onResumed() {
    widget.onResumed();
  }

  @override
  void onInactive() {
    widget.onInactive();
  }

  @override
  void onHidden() {
    widget.onHidden();
  }

  @override
  void onPaused() {
    widget.onPaused();
  }

  @override
  void onDetached() {
    widget.onDetached();
  }

  @override
  void onDispose() {
    widget.onDispose();

    if (createdByPage) {
      cubit.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>.value(
      value: cubit,
      child: BlocConsumer<C, S>(
        listenWhen: widget.listenWhen,
        listener: widget.listener,
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (BuildContext context, S state) {
          return switch (state.status) {
            BaseStatus.loading => widget.buildLoadingWidget(context, state),
            BaseStatus.failure => widget.buildErrorWidget(context, state),
            _ => widget.buildPage(context, state),
          };
        },
      ),
    );
  }
}
