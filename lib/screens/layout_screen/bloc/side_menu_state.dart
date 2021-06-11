part of 'side_menu_bloc.dart';

@immutable
class SideMenuState extends Equatable {
  final bool menuOpened;
  final bool buttonVisible;

  SideMenuState({
    required this.menuOpened,
    required this.buttonVisible
  });

  factory SideMenuState.initial() {
    return SideMenuState(
      menuOpened: false,
      buttonVisible: true
    );
  }

  SideMenuState update({
    bool? menuOpened,
    bool? buttonVisible
  }) => SideMenuState(
    menuOpened: menuOpened ?? this.menuOpened,
    buttonVisible: buttonVisible ?? this.buttonVisible
  );

  @override
  List<Object> get props => [menuOpened, buttonVisible];

  @override
  String toString() => 'SideMenuState { menuOpened: $menuOpened, buttonVisible: $buttonVisible }';
}
