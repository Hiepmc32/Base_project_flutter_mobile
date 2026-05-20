import 'package:fresh_base_project/base_run_main.dart';
import 'package:fresh_base_project/core/config/prod.config.dart';

Future<void> main() async {
  await BaseRunMain.runMainApp(config: ProdConfig());
}
