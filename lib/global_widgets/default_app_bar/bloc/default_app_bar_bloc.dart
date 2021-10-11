import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'default_app_bar_event.dart';
part 'default_app_bar_state.dart';

class DefaultAppBarBloc extends Bloc<DefaultAppBarEvent, DefaultAppBarState> {
  
  DefaultAppBarBloc()
    : super(DefaultAppBarState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Rotate>((event, emit) => _mapRotateToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapRotateToState({required Emitter<DefaultAppBarState> emit}) {
    emit(state.update(isRotated: true));
  }

  void _mapResetToState({required Emitter<DefaultAppBarState> emit}) {
    emit(state.update(isRotated: false));
  }
}
