import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class Debouncer {

  static EventTransformer<Event> bounce<Event>({required Duration duration}) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }
}