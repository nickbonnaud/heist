import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'logo_transaction_button_event.dart';
part 'logo_transaction_button_state.dart';

class LogoTransactionButtonBloc extends Bloc<LogoTransactionButtonEvent, LogoTransactionButtonState> {
  LogoTransactionButtonBloc() : super(LogoTransactionButtonState.initial());

  @override
  Stream<LogoTransactionButtonState> mapEventToState(LogoTransactionButtonEvent event) async* {
    if (event is TogglePressed) {
      yield state.update(isPressed: !state.pressed);
    }
  }
}
