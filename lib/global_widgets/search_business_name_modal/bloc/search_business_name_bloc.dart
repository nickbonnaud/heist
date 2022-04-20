import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:meta/meta.dart';

part 'search_business_name_event.dart';
part 'search_business_name_state.dart';

class SearchBusinessNameBloc extends Bloc<SearchBusinessNameEvent, SearchBusinessNameState> {
  final BusinessRepository _businessRepository;
  
  SearchBusinessNameBloc({required BusinessRepository businessRepository})
    : _businessRepository = businessRepository,
      super(SearchBusinessNameState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<BusinessNameChanged>((event, emit) async => await _mapBusinessNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: const Duration(milliseconds: 500)));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  Future<void> _mapBusinessNameChangedToState({required BusinessNameChanged event, required Emitter<SearchBusinessNameState> emit}) async {
    if (event.name.isNotEmpty) {
      emit(state.update(isSubmitting: true, errorMessage: ""));

      try {
        final PaginateDataHolder holder = await _businessRepository.fetchByName(name: event.name);
        emit(state.update(isSubmitting: false, businesses: holder.data as List<Business>));
      } on ApiException catch (exception) {
        emit(state.update(isSubmitting: false, errorMessage: exception.error));
      }
    } else {
      add(Reset());
    }
  }

  void _mapResetToState({required Emitter<SearchBusinessNameState> emit}) {
    emit(state.update(isSubmitting: false, businesses: null, resetBusinesses: true, errorMessage: ""));
  }
}
