import 'app/base_run_main.dart';
import 'app/config/dev.config.dart';

Future<void> main() async {
  await BaseRunMain.runMainApp(config: DevConfig());
}
