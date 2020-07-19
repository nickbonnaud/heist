import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'logo_business_button_event.dart';
part 'logo_business_button_state.dart';

class LogoBusinessButtonBloc extends Bloc<LogoBusinessButtonEvent, LogoBusinessButtonState> {
  LogoBusinessButtonBloc() : super(LogoBusinessButtonState.initial());

  @override
  Stream<LogoBusinessButtonState> mapEventToState(LogoBusinessButtonEvent event) async* {
    if (event is TogglePressed) {
      yield state.update(isPressed: !state.pressed);
    }
  }
}
