// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fresh_base_project/core/base/loading_controller.dart' as _i1055;
import 'package:fresh_base_project/core/di/app_module.dart' as _i568;
import 'package:fresh_base_project/core/themes/core/app_theme_manager.dart'
    as _i44;
import 'package:fresh_base_project/core/utils/device/device_manager.dart'
    as _i838;
import 'package:fresh_base_project/core/utils/logging/app_log.dart' as _i923;
import 'package:fresh_base_project/core/utils/network/auth_token_store.dart'
    as _i549;
import 'package:fresh_base_project/core/utils/network/connectivity_service.dart'
    as _i1071;
import 'package:fresh_base_project/core/utils/network/rest_service.dart'
    as _i50;
import 'package:fresh_base_project/core/utils/ui/app_locale_controller.dart'
    as _i712;
import 'package:fresh_base_project/features/main_tabs/presentation/controllers/main_tabs_controller.dart'
    as _i871;
import 'package:fresh_base_project/features/users/data/datasources/users_api_client.dart'
    as _i586;
import 'package:fresh_base_project/features/users/data/datasources/users_remote_data_source.dart'
    as _i27;
import 'package:fresh_base_project/features/users/data/repositories/users_repository_impl.dart'
    as _i524;
import 'package:fresh_base_project/features/users/domain/repositories/users_repository.dart'
    as _i192;
import 'package:fresh_base_project/features/users/domain/usecases/get_users_use_case.dart'
    as _i131;
import 'package:fresh_base_project/features/users/presentation/controllers/users_controller.dart'
    as _i814;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.preferences,
      preResolve: true,
    );
    await gh.factoryAsync<_i838.DeviceManager>(
      () => appModule.deviceManager,
      preResolve: true,
    );
    await gh.factoryAsync<_i923.AppLog>(
      () => appModule.appLog,
      preResolve: true,
    );
    await gh.factoryAsync<_i1071.ConnectivityService>(
      () => appModule.connectivityService,
      preResolve: true,
    );
    gh.factory<_i871.MainTabsController>(() => _i871.MainTabsController());
    gh.lazySingleton<_i1055.LoadingController>(
      () => _i1055.LoadingController(),
    );
    gh.lazySingleton<_i50.RestService>(() => appModule.restService);
    gh.lazySingleton<_i712.AppLocaleController>(
      () =>
          _i712.AppLocaleController(preferences: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i44.AppThemeManger>(
      () => appModule.appThemeManager(gh<_i460.SharedPreferences>()),
    );
    await gh.factoryAsync<_i549.AuthTokenStore>(
      () => appModule.authTokenStore(gh<_i460.SharedPreferences>()),
      preResolve: true,
    );
    gh.lazySingleton<_i586.UsersApiClient>(
      () => appModule.usersApiClient(gh<_i50.RestService>()),
    );
    gh.lazySingleton<_i27.UsersRemoteDataSource>(
      () =>
          _i27.UsersRemoteDataSourceImpl(apiClient: gh<_i586.UsersApiClient>()),
    );
    gh.lazySingleton<_i192.UsersRepository>(
      () => _i524.UsersRepositoryImpl(
        remoteDataSource: gh<_i27.UsersRemoteDataSource>(),
      ),
    );
    gh.factory<_i131.GetUsersUseCase>(
      () => _i131.GetUsersUseCase(gh<_i192.UsersRepository>()),
    );
    gh.factory<_i814.UsersController>(
      () => _i814.UsersController(getUsersUseCase: gh<_i131.GetUsersUseCase>()),
    );
    return this;
  }
}

class _$AppModule extends _i568.AppModule {}
