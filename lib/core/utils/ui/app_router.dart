import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_project/core/config/config.dart';
import 'package:fresh_base_project/core/utils/logging/alice.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/controllers/main_tabs_controller.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/pages/main_tabs_page.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_controller.dart';
import 'package:fresh_base_project/features/users/presentation/pages/users_page.dart';
import 'package:fresh_base_project/locator.dart';
import 'package:go_router/go_router.dart';

/// Centralized application router.
class AppRouter {
  AppRouter._();

  static const String mainTabsPath = '/';
  static const String usersPath = '/users';

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey:
        AppConfig.config.enableAlice
            ? AliceUtils().getNavigatorKey
            : navigatorKey,
    initialLocation: mainTabsPath,
    routes: <RouteBase>[
      GoRoute(
        path: mainTabsPath,
        name: 'mainTabs',
        builder:
            (BuildContext context, GoRouterState state) =>
                BlocProvider<MainTabsController>(
                  create: (_) => getIt<MainTabsController>(),
                  child: MainTabsPage(),
                ),
      ),
      GoRoute(
        path: usersPath,
        name: 'users',
        builder: (BuildContext context, GoRouterState state) {
          final UsersRouteParams params = UsersRouteParams.fromState(state);
          return BlocProvider<UsersController>(
            create: (_) => getIt<UsersController>(),
            child: UsersPage(showAppBar: params.showAppBar),
          );
        },
      ),
    ],
  );

  static Future<T?> pushUsers<T>(
    BuildContext context, {
    bool showAppBar = true,
  }) {
    return context.push<T>(UsersRouteParams(showAppBar: showAppBar).location);
  }

  static Widget buildUsersTab({required bool showAppBar}) {
    return BlocProvider<UsersController>(
      create: (_) => getIt<UsersController>(),
      child: UsersPage(showAppBar: showAppBar),
    );
  }
}

class UsersRouteParams {
  const UsersRouteParams({this.showAppBar = true});

  factory UsersRouteParams.fromState(GoRouterState state) {
    final String? showAppBarParam = state.uri.queryParameters['showAppBar'];
    return UsersRouteParams(
      showAppBar: showAppBarParam == null || showAppBarParam != 'false',
    );
  }

  final bool showAppBar;

  String get location {
    return Uri(
      path: AppRouter.usersPath,
      queryParameters:
          showAppBar ? null : <String, String>{'showAppBar': 'false'},
    ).toString();
  }
}
