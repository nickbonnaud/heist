import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'material_date_picker_event.dart';
part 'material_date_picker_state.dart';

enum Active {
  start,
  end
}

class MaterialDatePickerBloc extends Bloc<MaterialDatePickerEvent, MaterialDatePickerState> {
  @override
  MaterialDatePickerState get initialState => MaterialDatePickerState.initial();

  @override
  Stream<MaterialDatePickerState> mapEventToState(MaterialDatePickerEvent event) async* {
    if (event is DateChanged) {
      yield* _mapDateChangedToState(event);
    } else if (event is ActiveSelectionChanged) {
      yield* _mapActiveSelectionChangedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<MaterialDatePickerState> _mapDateChangedToState(DateChanged event) async* {
    yield state.active == Active.end
      ? state.update(endDate: event.date)
      : state.update(startDate: event.date);
  }

  Stream<MaterialDatePickerState> _mapActiveSelectionChangedToState(ActiveSelectionChanged event) async* {
    yield state.update(active: event.active);
  }

  Stream<MaterialDatePickerState> _mapResetToState() async* {
    yield MaterialDatePickerState.initial();
  }
}
