part of 'side_menu_bloc.dart';

abstract class SideMenuEvent extends Equatable {
  const SideMenuEvent();

  @override
  List<Object> get props => [];
}


class MenuStatusChanged extends SideMenuEvent {
  final bool menuOpen;

  MenuStatusChanged({@required this.menuOpen});

  @override
  List<Object> get props => [menuOpen];

  @override
  String toString() => 'MenuStatusChanged { menuOpen: $menuOpen }';
}

class DraggingMenu extends SideMenuEvent {
  final bool isDragging;

  DraggingMenu({@required this.isDragging});

  @override
  List<Object> get props => [isDragging];

  @override
  String toString() => 'DraggingMenu { isDragging: $isDragging }';
}

class FinishAnimation extends SideMenuEvent {}

class ToggleButtonVisibility extends SideMenuEvent {
  final bool isVisible;

  ToggleButtonVisibility({@required this.isVisible});

  @override
  List<Object> get props => [isVisible];

  @override
  String toString() => 'ToggleButtonVisibility { isVisible: $isVisible }';
}
