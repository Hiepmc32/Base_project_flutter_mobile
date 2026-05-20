import 'package:fresh_base_project/core/themes/core/app_theme_manager.dart';
import 'package:fresh_base_project/core/utils/device/device_manager.dart';
import 'package:fresh_base_project/core/utils/logging/app_log.dart';
import 'package:fresh_base_project/core/utils/network/auth_token_store.dart';
import 'package:fresh_base_project/core/utils/network/connectivity_service.dart';
import 'package:fresh_base_project/core/utils/network/rest_service.dart';
import 'package:fresh_base_project/features/users/data/datasources/users_api_client.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();

  @preResolve
  Future<DeviceManager> get deviceManager async {
    final DeviceManager manager = DeviceManager();
    await manager.init();
    return manager;
  }

  @preResolve
  Future<AppLog> get appLog async {
    final AppLog log = AppLog();
    await log.init();
    return log;
  }

  @preResolve
  Future<AuthTokenStore> authTokenStore(SharedPreferences preferences) async {
    final AuthTokenStore store = AuthTokenStore(preferences: preferences);
    await store.init();
    return store;
  }

  @preResolve
  Future<ConnectivityService> get connectivityService async {
    return ConnectivityService().init();
  }

  @lazySingleton
  AppThemeManger appThemeManager(SharedPreferences preferences) {
    return AppThemeManger(preferences: preferences);
  }

  @lazySingleton
  RestService get restService => RestService();

  @lazySingleton
  UsersApiClient usersApiClient(RestService restService) {
    return UsersApiClient(restService.dio);
  }
}
