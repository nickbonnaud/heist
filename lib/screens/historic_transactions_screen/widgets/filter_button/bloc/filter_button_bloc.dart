import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'filter_button_event.dart';
part 'filter_button_state.dart';

class FilterButtonBloc extends Bloc<FilterButtonEvent, FilterButtonState> {
  FilterButtonBloc()
    : super(FilterButtonState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Toggle>((event, emit) => _mapToggleToState(emit: emit));
  }

  void _mapToggleToState({required Emitter<FilterButtonState> emit}) async {
    emit(state.update(isActive: !state.isActive));
  }
}
