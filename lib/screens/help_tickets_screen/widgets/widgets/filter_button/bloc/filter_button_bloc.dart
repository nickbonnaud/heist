import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'filter_button_event.dart';
part 'filter_button_state.dart';

class FilterButtonBloc extends Bloc<FilterButtonEvent, FilterButtonState> {
  FilterButtonBloc() : super(FilterButtonState.initial());

  @override
  Stream<FilterButtonState> mapEventToState(FilterButtonEvent event) async* {
    if (event is Toggle) {
      yield state.update(isActive: !state.isActive);
    }
  }
}
