import 'dart:async';

import 'package:bloc/bloc.dart';


enum PermissionButtonsEvent { enable, disable }

class PermissionButtonsBloc extends Bloc<PermissionButtonsEvent, bool> {
  @override
  bool get initialState => true;

  @override
  Stream<bool> mapEventToState(PermissionButtonsEvent event) async* {
    yield event == PermissionButtonsEvent.enable;
  }
}
