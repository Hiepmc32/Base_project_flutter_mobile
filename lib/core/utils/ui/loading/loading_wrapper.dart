import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_project/core/base/loading_controller.dart';
import 'package:fresh_base_project/core/utils/ui/loading/app_loading.dart';

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child ?? const SizedBox.shrink(),
        BlocBuilder<LoadingController, bool>(
          builder: (BuildContext context, bool isLoading) {
            return Visibility(
              visible: isLoading,
              child: ColoredBox(
                color: const Color(0xFF131615).withValues(alpha: 0.5),
                child: appLoading,
              ),
            );
          },
        ),
      ],
    );
  }
}
