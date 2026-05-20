import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_base_project/app/config/config.dart';
import 'package:fresh_base_project/app/config/dev.config.dart';

void main() {
  test('dev config has default flavor', () {
    final BaseConfig config = DevConfig();
    expect(config.flavor, AppFlavor.dev);
  });
}
