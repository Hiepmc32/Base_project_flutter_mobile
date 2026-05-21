import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_project/app/themes/common/app_theme_type.dart';
import 'package:fresh_base_project/app/themes/core/app_theme_manager.dart';
import 'package:fresh_base_project/app/di/locator.dart';
import 'package:fresh_base_project/app/route/app_pages.dart';
import 'package:fresh_base_project/app/route/app_paths.dart';
import 'package:fresh_base_project/core/constants/app_locale_controller.dart';
import 'package:fresh_base_project/core/constants/base/base.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/cubit/main_tabs_cubit.dart';
import 'package:fresh_base_project/features/users/presentation/cubit/users_cubit.dart';
import 'package:fresh_base_project/features/users/presentation/pages/users_page.dart';
import 'package:go_router/go_router.dart';

/// Main shell page with bottom tabs, inspired by tacoin home bar flow.
class MainTabsPage extends BasePage<MainTabsCubit, MainTabsState> {
  MainTabsPage({super.key});

  static final GoRoute route = GoRoute(
    path: AppRoutePaths.mainTabs,
    name: Pages.mainTabs,
    builder:
        (_, _) => BlocProvider<MainTabsCubit>(
          create: (_) => getIt<MainTabsCubit>(),
          child: MainTabsPage(),
        ),
  );

  late final List<Widget> _tabs = <Widget>[
    const _StarterTab(
      icon: Icons.home_rounded,
      title: 'Home',
      description: 'Default tab for dashboard in a new project.',
    ),
    const _StarterTab(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Wallet',
      description: 'Sample tab for wallet or finance flows.',
    ),
    BlocProvider<UsersCubit>(
      create: (_) => getIt<UsersCubit>(),
      child: const UsersPage(showAppBar: false),
    ),
    const _MoreTab(),
  ];

  @override
  Widget buildPage(BuildContext context, MainTabsState state) {
    return Scaffold(
      body: IndexedStack(index: state.selectedIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.selectedIndex,
        onDestinationSelected: context.read<MainTabsCubit>().changeTab,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            selectedIcon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class _StarterTab extends StatelessWidget {
  const _StarterTab({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 52, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(title, style: textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton.tonal(
                  onPressed:
                      () => context.pushNamed(
                        Pages.users,
                        queryParameters: {'showAppBar': 'true'},
                      ),
                  child: const Text('Open Users Route'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreTab extends StatelessWidget {
  const _MoreTab();

  @override
  Widget build(BuildContext context) {
    final AppThemeType currentTheme = AppThemeManger().appTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            'More',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: const Text('Theme'),
              subtitle: Text(
                currentTheme == AppThemeType.light ? 'Light' : 'Dark',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _toggleTheme,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Language',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AppLocaleController, Locale>(
                    builder: (BuildContext context, Locale locale) {
                      return Wrap(
                        spacing: 8,
                        children: <Widget>[
                          ChoiceChip(
                            label: const Text('Tieng Viet'),
                            selected: locale.languageCode == 'vi',
                            onSelected: (bool selected) {
                              if (selected) {
                                context.read<AppLocaleController>().setLocale(
                                  const Locale('vi'),
                                );
                              }
                            },
                          ),
                          ChoiceChip(
                            label: const Text('English'),
                            selected: locale.languageCode == 'en',
                            onSelected: (bool selected) {
                              if (selected) {
                                context.read<AppLocaleController>().setLocale(
                                  const Locale('en'),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Open Users Full Page'),
              trailing: const Icon(Icons.chevron_right),
              onTap:
                  () => context.pushNamed(
                    Pages.users,
                    queryParameters: const <String, String>{
                      'showAppBar': 'true',
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTheme() {
    final AppThemeType currentTheme = AppThemeManger().appTheme;
    final AppThemeType nextTheme =
        currentTheme == AppThemeType.light
            ? AppThemeType.dark
            : AppThemeType.light;

    AppThemeManger().changeAppTheme(nextTheme);
  }
}
