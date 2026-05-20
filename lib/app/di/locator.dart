import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'locator.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() => getIt.init();

T locator<T extends Object>() => getIt<T>();

bool isRegistered<T extends Object>() => getIt.isRegistered<T>();
