import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'side_drawer_event.dart';
part 'side_drawer_state.dart';

class SideDrawerBloc extends Bloc<SideDrawerEvent, SideDrawerState> {
  SideDrawerBloc()
    : super(SideDrawerState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<DrawerStatusChanged>((event, emit) => _mapDrawerStatusChangedToState(event: event, emit: emit));
    on<ButtonVisibilityChanged>((event, emit) => _mapToggleButtonVisibilityToState(event: event, emit: emit));
  }

  void _mapDrawerStatusChangedToState({required DrawerStatusChanged event, required Emitter<SideDrawerState> emit}) async {
    emit(state.update(menuOpened: event.menuOpen, buttonVisible: !event.menuOpen));
  }

  void _mapToggleButtonVisibilityToState({required ButtonVisibilityChanged event, required Emitter<SideDrawerState> emit}) async {
    emit(state.update(buttonVisible: event.isVisible));
  }
}
