import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'search_business_name_event.dart';
part 'search_business_name_state.dart';

class SearchBusinessNameBloc extends Bloc<SearchBusinessNameEvent, SearchBusinessNameState> {
  final BusinessRepository _businessRepository;
  
  SearchBusinessNameBloc({required BusinessRepository businessRepository})
    : _businessRepository = businessRepository,
      super(SearchBusinessNameState.initial());

  @override
  Stream<Transition<SearchBusinessNameEvent, SearchBusinessNameState>> transformEvents(Stream<SearchBusinessNameEvent> events, TransitionFunction<SearchBusinessNameEvent, SearchBusinessNameState> transitionFn) {
    final nonDebounceStream = events.where((event) => event is !BusinessNameChanged);
    final debounceStream = events.where((event) => event is BusinessNameChanged)
      .debounceTime(Duration(milliseconds: 500));
    
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<SearchBusinessNameState> mapEventToState(SearchBusinessNameEvent event) async* {
    if (event is BusinessNameChanged) {
      yield* _mapBusinessNameChangedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<SearchBusinessNameState> _mapBusinessNameChangedToState({required BusinessNameChanged event}) async* {
    if (event.name.isNotEmpty) {
      yield state.update(isSubmitting: true, errorMessage: "");

      try {
        final PaginateDataHolder holder = await _businessRepository.fetchByName(name: event.name);
        yield state.update(isSubmitting: false, businesses: holder.data as List<Business>);
      } on ApiException catch (exception) {
        yield state.update(isSubmitting: false, errorMessage: exception.error);
      }
    } else {
      add(Reset());
    }
  }

  Stream<SearchBusinessNameState> _mapResetToState() async* {
    yield state.update(isSubmitting: false, businesses: null, resetBusinesses: true, errorMessage: "");
  }
}
