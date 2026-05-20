import 'base_mixin.dart';
import 'page_lifecycle_mixin.dart';

abstract class BasePage extends StatelessWidget with BaseMixin {
  const BasePage({super.key});

  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}

abstract class BaseStatefulPage extends StatefulWidget {
  const BaseStatefulPage({super.key});
}

abstract class BasePageState<T extends BaseStatefulPage> extends State<T>
    with BaseMixin, PageLifecycleMixin<T> {
  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}

@Deprecated('Use BasePage instead.')
abstract class BaseScreen extends BasePage {
  const BaseScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return builder(context);
  }

  @protected
  Widget builder(BuildContext context);
}

@Deprecated('Use BasePageState instead.')
abstract class BaseScreenStateful<SF extends StatefulWidget> extends State<SF>
    with BaseMixin {
  Widget builder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
