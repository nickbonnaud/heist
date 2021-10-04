import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/business/beacon.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:meta/meta.dart';

part 'active_location_event.dart';
part 'active_location_state.dart';

class ActiveLocationBloc extends Bloc<ActiveLocationEvent, ActiveLocationState> {
  final ActiveLocationRepository _activeLocationRepository;
  
  ActiveLocationBloc({required ActiveLocationRepository activeLocationRepository})
    : _activeLocationRepository = activeLocationRepository,
      super(ActiveLocationState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<NewActiveLocation>((event, emit) => _mapNewActiveLocationToState(event: event, emit: emit));
    on<RemoveActiveLocation>((event, emit) => _mapRemoveActiveLocationToState(event: event, emit: emit));
    on<TransactionAdded>((event, emit) => _mapTransactionAddedToState(event: event, emit: emit));
    on<ResetActiveLocations>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapNewActiveLocationToState({required NewActiveLocation event, required Emitter<ActiveLocationState> emit}) async {
    if (!state.activeLocations.any((activeLocation) => activeLocation.business.location.beacon == event.beacon) && !state.addingLocations.contains(event.beacon)) {
      emit(state.update(addingLocations: state.addingLocations + [event.beacon]));
      try {
        ActiveLocation activeLocation = await _activeLocationRepository.enterBusiness(beacon: event.beacon);
        
        emit(state.update(
          activeLocations: state.activeLocations + [activeLocation],
          addingLocations: state.addingLocations.where((beacon) => beacon != event.beacon).toList()
        ));
      } on ApiException catch (exception) {
        emit(state.update(
          errorMessage: exception.error,
          addingLocations: state.addingLocations.where((beacon) => beacon != event.beacon).toList()
        ));
      }
    }
  }

  void _mapRemoveActiveLocationToState({required RemoveActiveLocation event, required Emitter<ActiveLocationState> emit}) async {
    final ActiveLocation? locationToRemove = state.activeLocations
      .firstWhereOrNull((ActiveLocation activeLocation) => activeLocation.business.location.beacon == event.beacon);
    if (locationToRemove != null && !state.removingLocations.contains(event.beacon)) {
      emit(state.update(removingLocations: state.removingLocations + [event.beacon]));
      try {
        bool didRemove = await _activeLocationRepository.exitBusiness(activeLocationId: locationToRemove.identifier);
        if (didRemove) {
          final updatedActiveLocations = state
            .activeLocations
            .where((activeLocation) => activeLocation != locationToRemove)
            .toList();
          
          emit(state.update(
            activeLocations: updatedActiveLocations, 
            removingLocations: state.removingLocations.where((beacon) => beacon != event.beacon).toList()));
        } else {
          emit(state.update(
            errorMessage: "Unable to remove active location.",
            removingLocations: state.removingLocations.where((beacon) => beacon != event.beacon).toList()));
        }
      } on ApiException catch (exception) {
        emit(state.update(
          errorMessage: exception.error,
          removingLocations: state.removingLocations.where((beacon) => beacon != event.beacon).toList()));
      }
    }
  }

  void _mapTransactionAddedToState({required TransactionAdded event, required Emitter<ActiveLocationState> emit}) async {
    ActiveLocation? locationToUpdate = state.activeLocations.firstWhereOrNull((activeLocation) => activeLocation.business.identifier == event.business.identifier);

    if (locationToUpdate != null) {
      List<ActiveLocation> updatedLocations = state.activeLocations.where((activeLocation) => activeLocation != locationToUpdate).toList() + [locationToUpdate.update(transactionIdentifier: event.transactionIdentifier)];
      emit(state.update(activeLocations: updatedLocations));
    }
  }

  void _mapResetToState({required Emitter<ActiveLocationState> emit}) async {
    emit(state.update(errorMessage: ""));
  }
}
