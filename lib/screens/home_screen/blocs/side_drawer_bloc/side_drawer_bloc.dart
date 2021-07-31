import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'side_drawer_event.dart';
part 'side_drawer_state.dart';

class SideDrawerBloc extends Bloc<SideDrawerEvent, SideDrawerState> {
  SideDrawerBloc() : super(SideDrawerState.initial());

  @override
  Stream<SideDrawerState> mapEventToState(SideDrawerEvent event) async* {
    if (event is DrawerStatusChanged) {
      yield* _mapDrawerStatusChangedToState(event);
    } else if (event is ButtonVisibilityChanged) {
      yield* _mapToggleButtonVisibilityToState(event);
    }
  }

  Stream<SideDrawerState> _mapDrawerStatusChangedToState(DrawerStatusChanged event) async* {
    yield state.update(menuOpened: event.menuOpen, buttonVisible: !event.menuOpen);
  }

  Stream<SideDrawerState> _mapToggleButtonVisibilityToState(ButtonVisibilityChanged event) async* {
    yield state.update(buttonVisible: event.isVisible);
  }
}
