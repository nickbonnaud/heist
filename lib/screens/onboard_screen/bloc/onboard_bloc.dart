import 'dart:async';

import 'package:bloc/bloc.dart';


enum OnboardEvent {next, prev}

class OnboardBloc extends Bloc<OnboardEvent, int> {
  
  OnboardBloc() : super(0);

  @override
  Stream<int> mapEventToState(OnboardEvent event) async* {
    if (event == OnboardEvent.next) {
      yield state + 1;
    } else if (event == OnboardEvent.prev) {
      yield state - 1;
    }
  }
}
