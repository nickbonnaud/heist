part of 'side_menu_bloc.dart';

@immutable
class SideMenuState {
  final bool menuOpened;
  final bool disableContentTap;
  final bool isDraggingMenu;

  SideMenuState({
    @required this.menuOpened,
    @required this.disableContentTap,
    @required this.isDraggingMenu
  });

  factory SideMenuState.initial() {
    return SideMenuState(
      menuOpened: false,
      disableContentTap: true,
      isDraggingMenu: false
    );
  }

  SideMenuState update({
    bool menuOpened,
    bool disableContentTap,
    bool isDraggingMenu
  }) {
    return copyWith(
      menuOpened: menuOpened,
      disableContentTap: disableContentTap,
      isDraggingMenu: isDraggingMenu
    );
  }

  SideMenuState copyWith({
    bool menuOpened,
    bool disableContentTap,
    bool isDraggingMenu
  }) {
    return SideMenuState(
      menuOpened: menuOpened ?? this.menuOpened,
      disableContentTap: disableContentTap ?? this.disableContentTap,
      isDraggingMenu: isDraggingMenu ?? this.isDraggingMenu
    );
  }

  @override
  String toString() => 'SideMenuState { menuOpened: $menuOpened, disableContentTap: $disableContentTap, isDraggingMenu: $isDraggingMenu }';
}
