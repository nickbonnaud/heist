part of 'side_drawer_bloc.dart';

abstract class SideDrawerEvent extends Equatable {
  const SideDrawerEvent();

  @override
  List<Object> get props => [];
}

class DrawerStatusChanged extends SideDrawerEvent {
  final bool menuOpen;

  DrawerStatusChanged({required this.menuOpen});

  @override
  List<Object> get props => [menuOpen];

  @override
  String toString() => 'DrawerStatusChanged { menuOpen: $menuOpen }';
}


class ButtonVisibilityChanged extends SideDrawerEvent {
  final bool isVisible;

  ButtonVisibilityChanged({required this.isVisible});

  @override
  List<Object> get props => [isVisible];

  @override
  String toString() => 'ButtonVisibilityChanged { isVisible: $isVisible }';
}