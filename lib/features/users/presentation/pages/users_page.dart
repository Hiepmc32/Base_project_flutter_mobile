import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_project/core/base/base.dart';
import 'package:fresh_base_project/core/themes/common/app_theme_type.dart';
import 'package:fresh_base_project/core/themes/core/app_theme_manager.dart';
import 'package:fresh_base_project/core/utils/ui/app_locale_controller.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_controller.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_state.dart';
import 'package:fresh_base_project/features/users/presentation/widgets/user_card.dart';
import 'package:fresh_base_project/l10n/app_localizations.dart';

/// Users page that renders loading, empty, error and data states.
class UsersPage extends BasePage {
  const UsersPage({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  Widget buildPage(BuildContext context) {
    final Widget body = BlocBuilder<UsersController, UsersState>(
      builder: (BuildContext context, UsersState state) {
        return BaseListBody<UserEntity>(
          state: state,
          onRefresh: context.read<UsersController>().refreshItems,
          emptyMessage: AppLocalizations.of(context)!.noUsers(0),
          emptyIcon: const Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey,
          ),
          itemBuilder: (BuildContext context, UserEntity user) {
            return UserCard(
              user: user,
              onTap:
                  () =>
                      context.read<UsersController>().onUserTap(context, user),
            );
          },
        );
      },
    );

    if (!showAppBar) {
      return SafeArea(child: body);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.usersTitle,
          style: textStyle.regular(color: Colors.white),
        ),
        backgroundColor: color.primary,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.color_lens_outlined, color: Colors.white),
            tooltip: 'Theme',
            onPressed: _toggleTheme,
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: context.read<AppLocaleController>().setLocale,
            itemBuilder:
                (BuildContext context) => const <PopupMenuEntry<Locale>>[
                  PopupMenuItem<Locale>(
                    value: Locale('vi'),
                    child: Text('Tieng Viet'),
                  ),
                  PopupMenuItem<Locale>(
                    value: Locale('en'),
                    child: Text('English'),
                  ),
                ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: context.read<UsersController>().refreshItems,
          ),
        ],
      ),
      body: body,
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
