import 'package:bloc/bloc.dart';


enum PermissionButtonsEvent { enable, disable }

class PermissionButtonsBloc extends Bloc<PermissionButtonsEvent, bool> {
  
  PermissionButtonsBloc()
    : super(true) { _eventHandler(); }

  void _eventHandler() {
    on<PermissionButtonsEvent>((event, emit) => _mapPermissionButtonsEventToState(event: event, emit: emit));
  }

  void _mapPermissionButtonsEventToState({required PermissionButtonsEvent event, required Emitter<bool> emit}) async {
    emit(event == PermissionButtonsEvent.enable);
  }
}
