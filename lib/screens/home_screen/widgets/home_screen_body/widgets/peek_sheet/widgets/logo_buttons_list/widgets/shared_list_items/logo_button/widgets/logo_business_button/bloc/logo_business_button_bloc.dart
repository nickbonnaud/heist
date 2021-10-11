import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'logo_business_button_event.dart';
part 'logo_business_button_state.dart';

class LogoBusinessButtonBloc extends Bloc<LogoBusinessButtonEvent, LogoBusinessButtonState> {
  LogoBusinessButtonBloc()
    : super(LogoBusinessButtonState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<TogglePressed>((event, emit) => _mapTogglePressedToState(emit: emit));
  }

  void _mapTogglePressedToState({required Emitter<LogoBusinessButtonState> emit}) {
    emit(state.update(isPressed: !state.pressed));
  }
}
