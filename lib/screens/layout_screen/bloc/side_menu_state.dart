part of 'side_menu_bloc.dart';

@immutable
class SideMenuState {
  final bool menuOpened;
  final bool buttonVisible;

  SideMenuState({
    @required this.menuOpened,
    @required this.buttonVisible
  });

  factory SideMenuState.initial() {
    return SideMenuState(
      menuOpened: false,
      buttonVisible: true
    );
  }

  SideMenuState update({
    bool menuOpened,
    bool buttonVisible
  }) {
    return copyWith(
      menuOpened: menuOpened,
      buttonVisible: buttonVisible
    );
  }

  SideMenuState copyWith({
    bool menuOpened,
    bool buttonVisible
  }) {
    return SideMenuState(
      menuOpened: menuOpened ?? this.menuOpened,
      buttonVisible: buttonVisible ?? this.buttonVisible
    );
  }

  @override
  String toString() => 'SideMenuState { menuOpened: $menuOpened, buttonVisible: $buttonVisible }';
}
