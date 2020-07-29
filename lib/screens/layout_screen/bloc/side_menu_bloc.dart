import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'side_menu_event.dart';
part 'side_menu_state.dart';

class SideMenuBloc extends Bloc<SideMenuEvent, SideMenuState> {
  
  SideMenuBloc() : super(SideMenuState.initial());

  @override
  Stream<SideMenuState> mapEventToState(SideMenuEvent event) async* {
    if (event is MenuStatusChanged) {
      yield* _mapMenuStatusChangedToState(event);
    } else if (event is DraggingMenu) {
      yield* _mapDraggingMenuToState(event);
    } else if (event is ToggleButtonVisibility) {
      yield* _mapToggleButtonVisibilityToState(event);
    }
  }

  Stream<SideMenuState> _mapMenuStatusChangedToState(MenuStatusChanged event) async* {
    yield state.update(menuOpened: event.menuOpen, buttonVisible: !event.menuOpen);
  }

  Stream<SideMenuState> _mapDraggingMenuToState(DraggingMenu event) async* {
    yield state.update(isDraggingMenu: event.isDragging);
  }

  Stream<SideMenuState> _mapToggleButtonVisibilityToState(ToggleButtonVisibility event) async* {
    yield state.update(buttonVisible: event.isVisible);
  }
}