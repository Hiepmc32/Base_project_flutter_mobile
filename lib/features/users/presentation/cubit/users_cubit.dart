import 'package:fresh_base_project/core/constants/base/base.dart';
import 'package:fresh_base_project/core/types/result.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';
import 'package:fresh_base_project/features/users/domain/usecases/get_users_use_case.dart';
import 'package:fresh_base_project/features/users/presentation/cubit/users_state.dart';
import 'package:injectable/injectable.dart';

/// Cubit that maps domain results into UI state.
@injectable
class UsersCubit extends BaseListController<UserEntity> {
  UsersCubit({required GetUsersUseCase getUsersUseCase})
    : _getUsersUseCase = getUsersUseCase,
      super(UsersState()) {
    fetchItems();
  }

  final GetUsersUseCase _getUsersUseCase;

  @override
  ResultFuture<List<UserEntity>> loadItems() => _getUsersUseCase();

  /// Handles a user item click event.
  void onUserTap(BuildContext context, UserEntity user) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('You selected: ${user.name}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
