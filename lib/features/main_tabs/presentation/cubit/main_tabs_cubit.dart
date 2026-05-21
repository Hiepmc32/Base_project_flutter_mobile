import 'package:fresh_base_project/core/constants/base/base.dart';
import 'package:injectable/injectable.dart';

class MainTabsState extends BaseState {
  const MainTabsState({super.status, this.selectedIndex = 0});

  final int selectedIndex;

  @override
  MainTabsState copyWith({BaseStatus? status, int? selectedIndex}) {
    return MainTabsState(
      status: status ?? this.status,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, selectedIndex];
}

/// Cubit that handles current index for bottom tabs.
@injectable
class MainTabsCubit extends BaseCubit<MainTabsState> {
  MainTabsCubit() : super(const MainTabsState());

  /// Changes active tab by [index].
  void changeTab(int index) {
    if (index == state.selectedIndex) {
      return;
    }
    emit(state.copyWith(selectedIndex: index));
  }
}
