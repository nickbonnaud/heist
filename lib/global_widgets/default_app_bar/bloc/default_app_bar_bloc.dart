import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'default_app_bar_event.dart';
part 'default_app_bar_state.dart';

class DefaultAppBarBloc extends Bloc<DefaultAppBarEvent, DefaultAppBarState> {
  @override
  DefaultAppBarState get initialState => DefaultAppBarState.initial();

  @override
  Stream<DefaultAppBarState> mapEventToState(DefaultAppBarEvent event) async* {
    if (event is Rotate) {
      yield state.update(isRotated: true);
    } else if (event is Reset) {
      yield state.update(isRotated: false);
    }
  }
}
