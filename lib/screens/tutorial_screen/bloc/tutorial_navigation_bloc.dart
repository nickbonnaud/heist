import 'package:flutter_bloc/flutter_bloc.dart';

import 'slide_changed.dart';

class TutorialNavigationBloc extends Bloc<SlideChanged, int> {

  TutorialNavigationBloc() : super(0);

  @override
  Stream<int> mapEventToState(SlideChanged event) async* {
    if (event is SlideChanged) {
      yield event.index;
    }
  }
}