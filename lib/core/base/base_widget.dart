import 'base_mixin.dart';

export 'package:flutter/material.dart';

abstract class BaseWidget extends StatelessWidget with BaseMixin {
  const BaseWidget({super.key});

  String? screenName() => '';

  Widget builder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
