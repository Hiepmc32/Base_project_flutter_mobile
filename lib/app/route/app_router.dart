import 'package:flutter/material.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/pages/main_tabs_page.dart';
import 'package:fresh_base_project/features/users/presentation/pages/users_page.dart';
import 'package:go_router/go_router.dart';

import '../../common/utils/logging/alice.dart';
import '../config/config.dart';
import 'app_paths.dart';

/// Centralized application router.
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey:
        AppConfig.config.enableAlice
            ? AliceUtils().getNavigatorKey
            : navigatorKey,
    initialLocation: AppRoutePaths.mainTabs,
    routes: <RouteBase>[MainTabsPage.route, UsersPage.route],
  );
}
