part of 'side_drawer_bloc.dart';

@immutable
class SideDrawerState extends Equatable {
  final bool menuOpened;
  final bool buttonVisible;

  const SideDrawerState({
    required this.menuOpened,
    required this.buttonVisible
  });

  factory SideDrawerState.initial() {
    return const SideDrawerState(
      menuOpened: false,
      buttonVisible: true
    );
  }

  SideDrawerState update({
    bool? menuOpened,
    bool? buttonVisible
  }) => SideDrawerState(
    menuOpened: menuOpened ?? this.menuOpened,
    buttonVisible: buttonVisible ?? this.buttonVisible
  );

  @override
  List<Object> get props => [menuOpened, buttonVisible];

  @override
  String toString() => 'SideDrawerState { menuOpened: $menuOpened, buttonVisible: $buttonVisible }';
}
