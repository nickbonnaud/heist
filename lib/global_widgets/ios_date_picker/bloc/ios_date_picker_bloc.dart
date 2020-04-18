import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'ios_date_picker_event.dart';
part 'ios_date_picker_state.dart';

enum Active {
  start,
  end
}

class IosDatePickerBloc extends Bloc<IosDatePickerEvent, IosDatePickerState> {
  @override
  IosDatePickerState get initialState => IosDatePickerState.initial();

  @override
  Stream<IosDatePickerState> transformEvents(Stream<IosDatePickerEvent> events, Stream<IosDatePickerState> Function(IosDatePickerEvent) next) {
    final nonDebounceStream = events.where((event) => event is !DateChanged);
    final debounceStream = events.where((event) => event is DateChanged)
      .debounceTime(Duration(milliseconds: 500));
      
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }
  
  @override
  Stream<IosDatePickerState> mapEventToState(IosDatePickerEvent event) async* {
    if (event is DateChanged) {
      yield* _mapDateChangedToState(event);
    } else if (event is ActiveSelectionChanged) {
      yield* _mapActiveSelectionChangedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<IosDatePickerState> _mapDateChangedToState(DateChanged event) async* {
    yield state.active == Active.end
      ? state.update(endDate: event.date)
      : state.update(startDate: event.date);
  }

  Stream<IosDatePickerState> _mapActiveSelectionChangedToState(ActiveSelectionChanged event) async* {
    yield state.update(active: event.active);
  }

  Stream<IosDatePickerState> _mapResetToState() async* {
    yield IosDatePickerState.initial();
  }
}
