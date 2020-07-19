part of 'side_menu_bloc.dart';

@immutable
class SideMenuState {
  final bool menuOpened;
  final bool disableContentTap;
  final bool isDraggingMenu;
  final bool buttonVisible;

  SideMenuState({
    @required this.menuOpened,
    @required this.disableContentTap,
    @required this.isDraggingMenu,
    @required this.buttonVisible
  });

  factory SideMenuState.initial() {
    return SideMenuState(
      menuOpened: false,
      disableContentTap: true,
      isDraggingMenu: false,
      buttonVisible: true
    );
  }

  SideMenuState update({
    bool menuOpened,
    bool disableContentTap,
    bool isDraggingMenu,
    bool buttonVisible
  }) {
    return copyWith(
      menuOpened: menuOpened,
      disableContentTap: disableContentTap,
      isDraggingMenu: isDraggingMenu,
      buttonVisible: buttonVisible
    );
  }

  SideMenuState copyWith({
    bool menuOpened,
    bool disableContentTap,
    bool isDraggingMenu,
    bool buttonVisible
  }) {
    return SideMenuState(
      menuOpened: menuOpened ?? this.menuOpened,
      disableContentTap: disableContentTap ?? this.disableContentTap,
      isDraggingMenu: isDraggingMenu ?? this.isDraggingMenu,
      buttonVisible: buttonVisible ?? this.buttonVisible
    );
  }

  @override
  String toString() => 'SideMenuState { menuOpened: $menuOpened, disableContentTap: $disableContentTap, isDraggingMenu: $isDraggingMenu, buttonVisible: $buttonVisible }';
}
