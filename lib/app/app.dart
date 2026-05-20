import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fresh_base_project/core/constants/base/base.dart';

import '../common/utils/logging/alice.dart';
import '../common/widget/loading/loading_wrapper.dart';
import '../core/constants/app_locale_controller.dart';
import '../l10n/app_localizations.dart';
import 'config/config.dart';
import 'di/locator.dart';
import 'route/app_router.dart';
import 'themes/themes.dart';

/// Root app widget.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeManger themeManager = getIt<AppThemeManger>();

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<LoadingController>.value(
          value: getIt<LoadingController>(),
        ),
        BlocProvider<AppLocaleController>.value(
          value: getIt<AppLocaleController>(),
        ),
      ],
      child: AnimatedBuilder(
        animation: themeManager,
        builder: (BuildContext context, _) {
          return GestureDetector(
            onLongPress:
                AppConfig.config.enableAlice
                    ? () => AliceUtils().alice?.showInspector()
                    : null,
            child: BlocBuilder<AppLocaleController, Locale>(
              builder: (BuildContext context, Locale locale) {
                return MaterialApp.router(
                  onGenerateTitle:
                      (BuildContext context) => AppConfig.config.appName,
                  theme: themeManager.themeData,
                  localizationsDelegates:
                      const <LocalizationsDelegate<dynamic>>[
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                  supportedLocales: const <Locale>[Locale('vi'), Locale('en')],
                  locale: locale,
                  routerConfig: AppRouter.router,
                  debugShowCheckedModeBanner: false,
                  builder: (BuildContext context, Widget? child) {
                    return LoadingWrapper(
                      child: child ?? const SizedBox.shrink(),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
