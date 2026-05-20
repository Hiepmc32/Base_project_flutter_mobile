import 'package:fresh_base_project/core/config/config.dart';

class ProdConfig extends BaseConfig {
  @override
  AppFlavor get flavor => AppFlavor.prod;
}
