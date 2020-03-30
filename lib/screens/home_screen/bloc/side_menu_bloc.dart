import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'side_menu_event.dart';
part 'side_menu_state.dart';

class SideMenuBloc extends Bloc<SideMenuEvent, SideMenuState> {
  @override
  SideMenuState get initialState => SideMenuState.initial();

  @override
  Stream<SideMenuState> mapEventToState(SideMenuEvent event) async* {
    if (event is MenuPressed) {
      yield* _mapMenuPressedToState();
    } else if (event is MenuStatusChanged) {
      yield* _mapMenuStatusChangedToState(event);
    } else if (event is DraggingMenu) {
      yield* _mapDraggingMenuToState(event);
    }
  }

  Stream<SideMenuState> _mapMenuPressedToState() async* {
    yield state.update(menuOpened: !state.menuOpened);
  }

  Stream<SideMenuState> _mapMenuStatusChangedToState(MenuStatusChanged event) async* {
    yield state.update(menuOpened: event.menuOpen);
  }

  Stream<SideMenuState> _mapDraggingMenuToState(DraggingMenu event) async* {
    yield state.update(isDraggingMenu: event.isDragging);
  }
}
