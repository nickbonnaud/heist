import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'logo_transaction_button_event.dart';
part 'logo_transaction_button_state.dart';

class LogoTransactionButtonBloc extends Bloc<LogoTransactionButtonEvent, LogoTransactionButtonState> {
  LogoTransactionButtonBloc()
    : super(LogoTransactionButtonState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<TogglePressed>((event, emit) => _mapTogglePressedToState(emit: emit));
  }

  void _mapTogglePressedToState({required Emitter<LogoTransactionButtonState> emit}) {
    emit(state.update(isPressed: !state.pressed));
  }
}
